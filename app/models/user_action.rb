class UserAction
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :user_id,  type: Integer
  field :obj_type, type: String
  field :obj_id,   type: String
  field :event,    type: String

  def object= new_object
    self.obj_type = new_object.class.to_s
    self.obj_id   = new_object.id
  end

  def object
    # FFR
    # http://infovore.org/archives/2006/08/02/getting-a-class-object-in-ruby-from-a-string-containing-that-classes-name/
    obj_class = Object.const_get(obj_type)
    obj_class.find obj_id
  rescue 
    false
  end

  def type
    event.to_s + " " + obj_type.to_s 
  end
end
