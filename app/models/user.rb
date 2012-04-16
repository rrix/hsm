class User 
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :first_name,
                  :last_name,
                  :role

  belongs_to :role
  has_many   :user_actions

  # User fields
  field :first_name,    type: String, null: false
  field :last_name,     type: String, null: false
  field :skill_summary, type: String, null: false

  # Include default devise modules
  devise :confirmable,
         :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  ## Database authenticatable
  field :email,              type: String, null: false
  field :encrypted_password, type: String, null: false

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Encryptable
  # field :password_salt, type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  # Token authenticatable
  field :authentication_token, type: String
  
  # Validations
  validates_uniqueness_of :email,     case_sensitive: false
  validates_presence_of   :first_name
  validates_presence_of   :last_name

  #
  # Helper Methods
  def gravatar_url size=80
    hash = Digest::MD5.hexdigest(email.downcase.strip)
    "http://www.gravatar.com/avatar/#{hash}?s=#{size}"
  end

  before_validation(on: :create) do
    self.role = Role.where(name: "User").first unless self.role
  end

  def full_name
      first_name + " " + last_name
  end

  def name
    full_name
  end

  def has_permission?(perm)
    if not role.nil?
      role.permissions.each do |uperm|
        return true if uperm.name == perm
      end
    end  
    return false
  end

private

  # Implements magic such as @user.is_an_admin_or_superhero?
  # and @user.can_fly?
  def method_missing(method_id, *args)
    if match = matches_dynamic_role_check?(method_id)
        tokenize_roles(match.captures.first).each do |check|
            return true if role and role.name.downcase == check
        end
        return false
    elsif match = matches_dynamic_perm_check?(method_id)
        return true if has_permission?("administrate")
        return true if role and permissions.find_by_name(match.captures.first)
        return false
    else
        super
    end
  end

  private

  def matches_dynamic_perm_check?(method_id)
    /^can_([a-zA-Z]\w*)\?$/.match(method_id.to_s)
  end

  def matches_dynamic_role_check?(method_id)
    /^is_an?_([a-zA-Z]\w*)\?$/.match(method_id.to_s)
  end

  def tokenize_roles(string_to_split)
    string_to_split.split(/_or_/)
  end

end
