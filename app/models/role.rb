class Role
  include Mongoid::Document

  has_many :users

  field :name,        :type => String
  field :description, :type => String
end
