# == Schema Information
#
# Table name: events
#
#  id                                   :integer         not null, primary key
#  owner_id                             :integer
#  created_at                           :datetime
#  updated_at                           :datetime
#  name                                 :string(255)
#  datetime                             :datetime
#  timezone                             :string(255)
#  description                          :text
#  venue_id                             :integer
#  public                               :boolean         default(FALSE), not null
#  public_seats                         :integer         default(0)
#  automatic_public_invitation_approval :boolean         default(FALSE)
#

require 'spec_helper'

require 'pp'

describe Event do
  pending "add some examples to (or delete) #{__FILE__}"
  before do
    @user = Factory :user

    @guest0 = Factory :user
    @guest1 = Factory :user

    #Gmaps4rails.stub!(:geocode).and_return([{:lat => 33, :lng => 33, :matched_address => ""}])

    
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

  end

end
