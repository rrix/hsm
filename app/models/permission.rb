class Permission
  include Mongoid::Document

  has_and_belongs_to_many :roles
end
