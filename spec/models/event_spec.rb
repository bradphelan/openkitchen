# == Schema Information
#
# Table name: events
#
#  id          :integer         not null, primary key
#  owner_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string(255)
#  datetime    :datetime
#  timezone    :string(255)
#  description :text
#  venue_id    :integer
#

require 'spec_helper'

require 'pp'

describe Event do
  pending "add some examples to (or delete) #{__FILE__}"
  before do
    @user = Factory :user
    @profile = @user.profile

    @profile.save!

    @guest0 = Factory :user
    @guest1 = Factory :user

    Gmaps4rails.stub!(:geocode).and_return([{:lat => 33, :lng => 33, :matched_address => ""}])

    
  end
  describe "creating" do
    before do
      @event = @user.events_as_owner.build :timezone => "UTC", :description => "Bar", :name => "Foo" do |e|
        e.venue = @user.venues.first
        e.datetime = Time.zone.now + 2.weeks
      end
      @event.save!
    end

    it "should create the event and assign the user as owner" do
      @event.owner.should == @user
      @event.invitations.count.should == 1
    end

    describe "#invitees" do
      before do
        @event.invitees << @guest0
        @event.invitees << @guest1
      end
      
      it "should return all the invited guests" do

        invitees = Event.find(@event.id).invitees
        invitees.should include(@guest0)
        invitees.should include(@guest1)

      end

      it "should create invitations with unique tokens" do
        @event.invitations.count.should == 3
        tokens = @event.invitations.map &:token
        tokens[0].should_not == tokens[1]
        tokens[0].length.should == 64
        tokens[1].length.should == 64
      end
    end

    describe "#invite_by_email" do
      before do
        @guest_email0 = "johnny@moocool.com"
        @guest_email1 = "sarah@moocool.com"
        @event.invite @guest_email0
      end
      it "should create a user if it does not yet exist" do
        User.where{email==my{@guest_email0}}.count.should == 1
      end
      it "should add the user to the invitees" do
        user = User.where{email==my{@guest_email0}}.first
        @event.invitees.should include(user)
      end


    end

  end

end
