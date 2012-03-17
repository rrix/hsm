FactoryGirl.define do

  factory :user, :class => User do
    first_name              'first_name'
    last_name               'last_name'
    email                   'first_name.last_name@example.com'
    password                'password'
    password_confirmation   'password'
  end
  
  factory :role do
  end

  factory :user_action do
  end

end
