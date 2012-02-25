# == Schema Information
#
# Table name: invitations
#
#  id                         :integer         not null, primary key
#  event_id                   :integer
#  user_id                    :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#  token                      :string(255)
#  status                     :string(255)     default("pending")
#  comment_subscription_state :string(255)     default("auto")
#

require 'spec_helper'

shared_steps "setup" do
  Given "an event, the event's owner and a guest" do
    @owner = Factory :registered_user
    @guest = Factory :user
    @event = Factory :event, :owner => @owner
    @owner_invitation = @event.invitation_for_user @owner
    GirlFriday::WorkQueue.immediate!
  end
end

describe Invitation do
  Steps do
    include_steps "setup"

    Then "the owner is automatically subscribed to comments" do
      @owner_invitation.should be_subscribed_for_comments
    end

    When "subscription is toggled" do
      @owner_invitation.toggle_subscription!
    end 

    Then "the owner is unsubscribed from comments" do
      @owner_invitation.should_not be_subscribed_for_comments
    end

    When "subscription is toggled again" do
      @owner_invitation.toggle_subscription!
    end 

    Then "the owner is subscribed to comments" do
      @owner_invitation.should be_subscribed_for_comments
    end
  end

  Steps do
    include_steps "setup"

    Then "the owner is automatically subscribed to comments" do
      @owner_invitation.should be_subscribed_for_comments
    end

    When "the guest is invited to the event" do
      @invitation = @event.invite @guest
    end

    Then "the guest should not yet be subscribed to comments" do
      @invitation.should_not be_subscribed_for_comments
    end

    When "the guest makes a comment" do
      @comment = Comment.build_from(@event, @guest.id, "foo")
      @comment.save!
    end

    Then "the guest should be subscribed to comments" do
      @invitation.reload
      @invitation.should be_subscribed_for_comments
    end

    When "the guest is unsubscribed to comments" do
      @invitation.unsubscribe_for_comments!
    end

    And "the guest makes a comment" do
      @comment = Comment.build_from(@event, @guest.id, "foo")
      @comment.save!
    end

    Then "the guest should not be subscribed to comments" do
      @invitation.reload
      @invitation.should_not be_subscribed_for_comments
    end
  end

end
