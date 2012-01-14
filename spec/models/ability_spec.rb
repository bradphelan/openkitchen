require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  before :each do
    @user0 = Factory :user
    @user1 = Factory :user

    @event0 = Factory :event, :owner => @user0
    @event1 = Factory :event, :owner => @user1
    @event2 = Factory :event, :owner => @user1

    @invitation0 = @event2.invite @user0.email
    @invitation1 = @event2.invite @user1.email

    @resource0 = @event0.resources.create! :name => "xxx"
    @resource1 = @event1.resources.create! :name => "yyy"

    @resource_producer0 = ResourceProducer.new :resource => @resource0, :invitation => @invitation0
    @resource_producer1 = ResourceProducer.new :resource => @resource0, :invitation => @invitation1
    @resource_producer2 = ResourceProducer.new :resource => @resource1, :invitation => @invitation0
  end

  subject { Ability.new(@user0) }

  it { should be_able_to :edit, @event0 }
  it { should_not be_able_to :edit, @event1 }

  it { should be_able_to :update, @event0 }
  it { should_not be_able_to :update, @event1 }

  describe "Invitation abilities" do
    it { should_not be_able_to :show, @event1 }
    it { should be_able_to :show, @event2 }
  end

  describe "Resource producer abilities" do
    it { should be_able_to :show, @resource0 }
    it { should_not be_able_to :show, @resource1 }

    it { should be_able_to :create, @resource_producer0 }


    # the invite on the resource_producer is not user
    it { should_not be_able_to :create, @resource_producer1 }
    
    # the invite on the resource does not have an event with an invite for user
    it { should_not be_able_to :create, @resource_producer2 }
  end
end