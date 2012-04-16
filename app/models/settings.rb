class Settings
  include Mongoid::AppSettings

  setting :group_name,    default: 'Your Friendly Hackerspace'
  setting :new_user_role, default: 'User'

  # add new settings here
end
