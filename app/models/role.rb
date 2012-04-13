class Role
  include Mongoid::Document

  has_many :users
end
