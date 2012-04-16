class Role
  include Mongoid::Document

  has_many :users
  has_many :permissions

  field :name,        :type => String
  field :description, :type => String
end
