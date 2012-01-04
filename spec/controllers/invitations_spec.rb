describe InvitationsController do
  include Devise::TestHelpers
  
  before do
    @owner = Factory :user
    @guest = Factory :user
    @event = @owner.events_as_owner.create
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
    it {should redirect_to edit_invitation_url(:id => @invite.id)}
  end
end
