class Role
  include Mongoid::Document

  belongs_to :user 
  has_many   :users

  field :name,        :type => String
  field :description, :type => String
end
