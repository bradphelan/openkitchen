describe InvitationsController do
  include Devise::TestHelpers
  
  before do

    #Gmaps4rails.stub!(:geocode).and_return([{:lat => 33, :lng => 33, :matched_address => ""}])

    
    @owner = Factory :user
    @guest = Factory :user
    @event = @owner.events_as_owner.create! :timezone => "UTC", :name => "foo", :datetime => Time.zone.now do |e|
      e.venue = @owner.venues.first
    end
    @invite = @event.invite @guest.email
  end
  describe "GET bad token" do
    it "should raise a not found exception if the token cannot be found" do
      proc do
        get :token, :id => "ASDFASFASDF"
      end.should raise_error(ActiveRecord::RecordNotFound)

    end
  end
  describe "GET good token" do
    before do
        get :token, :id => @invite.token
    end
    it {should redirect_to event_url(@invite.event)}
  end
end
