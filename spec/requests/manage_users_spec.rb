require 'spec_helper'

describe 'Managing Users' do

  before do
    @role = Factory.create :role, :name => "User"
  end
  
  describe 'User sign up' do

    it 'has a link to sign up' do
      visit root_url

      page.should have_css("a[href='#{ new_user_registration_path }']")
    end

    context 'with valid information' do

      it 'creates an account' do
        visit new_user_registration_path
        fill_in_fields :user, :first_name            => 'Phillip',
                              :last_name             => 'Fry',
                              :email                 => 'pfry@test.com',
                              :password              => 'password',
                              :password_confirmation => 'password'

        click_button 'Sign up'

        should_be_on root_path
        page.should have_content 'A message with a confirmation link has been sent to your email address. Please open the link to activate your account.'
        User.last.email.should == 'pfry@test.com'
      end

    end

    context 'with invalid information' do

      it 'does not create an account' do
        visit new_user_registration_path
        click_button 'Sign up'

        page.should have_content 'errors prohibited this user from being saved'

        User.count.should == 0
      end

    end

    describe 'Confirmation Email' do

      it 'should send a confirmation email upon user creation' do
        clear_emails
        Factory.create(:user)

        sent_emails.should have(1).email
      end

    end

  end

  describe 'editing account info' do

    before do
      @user = Factory.create :user, :first_name => 'Phillip',
                                    :last_name  => 'Fry',
                                    :role       => @role

      login_as @user
    end

    it 'has a link to edit account' do
      visit root_url

      page.should have_css('a', :text => @user.full_name)
    end

    context 'with valid information' do

      it 'updates the user' do
        visit edit_user_registration_path
        fill_in_fields :user, :email            => 'new_email@test.com',
                              :current_password => 'password'

        click_button 'Update'

        page.should have_content 'You updated your account successfully.'
        @user.reload.email.should == 'new_email@test.com'
      end

    end

    context 'with invalid information' do

      it 'does not updates the user' do
        visit edit_user_registration_path
        fill_in_fields :user, :email => 'new_email@test.com'

        click_button 'Update'

        page.should have_content    'error prohibited this user from being saved'
        page.should have_no_content 'You updated your account successfully.'

        @user.reload.email.should_not == 'new_email@test.com'
      end

    end

  end

  describe 'deleting account' do

    before do
      @user = Factory.create :user, :email                 => 'user@test.com',
                                    :password              => 'password',
                                    :password_confirmation => 'password',
                                    :confirmed_at          => Time.now

      login_as @user
    end

    it 'has a link to remove account on the edit page' do
      visit edit_user_registration_path(@user)

      page.should have_css('a', :text => 'Delete my account')
    end

    it 'user can remove account', :js => true do
      visit edit_user_registration_path(@user)
      click_link 'Delete my account!'

      alert = page.driver.browser.switch_to.alert
      alert.text.should == "Are you sure?"

      alert.accept

      should_be_on root_path
      page.should have_content('Bye! Your account was successfully cancelled. We hope to see you again soon.')
    end

  end

  describe 'viewing profile' do

    before do
      @user   = Factory.create :user,  :skill_summary  => "I do awesome stuff so hard"
      # TODO: This needs to be moved to hsm_skills
      # @skill  = Factory.create :skill, :name           => "Doing Awesome Stuff"
      # @skill.assign_to @user, @user, 5
      @user.save
    end

    context 'logged in as user' do

      before do
        login_as @user
      end

      it 'should have a link to view the user\'s profile from the menu' do
        visit root_path

        click_link @user.full_name
        page.should have_content "My Profile"
      end

      it 'clicking the profile link should take you to the user profile' do
        visit root_path

        click_link @user.full_name
        click_link "My Profile"

        page.should have_content @user.full_name
        page.should have_content 'Biography'
        # page.should have_content 'Skills'
      end

      it 'should have links to edit info' do
        visit user_path @user

        page.should have_content "Edit Information"
      end

      it 'should have links to add skills' do
       fail "This needs to be moved to hsm_skills"
       visit user_path @user

       page.should have_content "Add skill"
      end

    end

    context 'not logged in as user' do

      it 'should show a link to the user index on the homepage' do
        visit root_path

        page.should have_css "a[href='#{ users_path }']"
      end

      it 'should show all the users on the user index' do
        visit users_path

        page.should have_content @user.full_name
      end

      it 'should show a link to view each profile on the user index' do
        visit users_path

        page.should have_css "a[href='#{user_path @user}']"
      end

      it 'should display the user biography on the profile page' do
        visit user_path @user

        page.should have_content "Biography"
        page.should have_content @user.skill_summary
      end

      it 'should display the user gravatar image' do
        visit user_path @user

        page.should have_css "img[src='#{ @user.gravatar_url }']"
      end

    end

  end

end
