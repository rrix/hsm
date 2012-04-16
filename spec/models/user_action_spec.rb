require 'spec_helper'

describe UserAction do
  let (:user) { Factory :user }

  before do
    pending "Needs to be rewritten without tool object"
    # TODO: Move tool actions in to hsm_tools
    action.object = tool
    action.save
  end

  it 'should have a type' do
    @action.type.should == 'created User'
  end

  it 'should be attached to a user' do
    @action.user.should == user
  end

  it 'should have a date and time' do
    @action.created_at.should
  end

  it 'should have an object_type' do
      @action.obj_type.should == tool.class.to_s
  end

  it 'should have an object_id' do
    @action.obj_id.should == tool.id
  end

  it 'should have an object' do
    @action.object.should == tool
  end
end
