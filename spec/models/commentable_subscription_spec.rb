require 'spec_helper'

describe CommentableSubscription do
  before do
    @owner = Factory :registered_user
    @guest = Factory :registered_user
    @event = Factory :event, :owner => @owner
    @guest_invitation = @event.invite @guest
    LazyWorkQueue.stub :push do |*args|
      # We don't want email errors
    end
  end

  it "By default a user should not be subscribed" do
    @event.subscribed_on_comments?(@guest).should be_false
  end

  it "should be possible to subscribe any user to comments" do
    @event.subscribed_on_comments?(@guest).should be_false
    @event.subscribe_to_comments @guest
    @event.subscribed_on_comments?(@guest).should be_true
    @event.unsubscribe_from_comments @guest
    @event.subscribed_on_comments?(@guest).should be_false
    @event.toggle_comment_subscription(@guest)
    @event.subscribed_on_comments?(@guest).should be_true
    @event.toggle_comment_subscription(@guest)
    @event.subscribed_on_comments?(@guest).should be_false
  end

  it "create a comment should subscribe a user if no subscription object exists" do
    @event.subscribed_on_comments?(@guest).should be_false
    @comment = Comment.build_from(@event, @guest.id, "bar")
    @comment.save!
    @event.subscribed_on_comments?(@guest).should be_true
  end

  it "create a comment should not subscribe a user if no subscription object exists" do
    @event.unsubscribe_from_comments @guest
    @event.subscribed_on_comments?(@guest).should be_false
    @comment = Comment.build_from(@event, @guest.id, "bar")
    @event.subscribed_on_comments?(@guest).should be_false
  end
end
