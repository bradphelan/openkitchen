module CommentSubscriber

  def self.included base
    base.class_eval do
      has_many :commentable_subscriptions, :as => :commentable, :dependent => :destroy
    end
  end

  # Returns a subscription ( or nil ) for the :user
  def subscription_on_comments user
    commentable_subscriptions.where{user_id == user.id}.first 
  end

  # Returns true if the :user is subscribed for email notifications
  # on the comments
  def subscribed_on_comments? user
    s = subscription_on_comments user
    if s
      return s.subscribed?
    else
      false
    end
  end

  # Build a new comment subscription for the user
  def build_comment_subscription user
    commentable_subscriptions.where{user_id == user.id}.build
  end

  # Find a subscription or build a new one
  def find_or_build_comment_subscription user
    unless subscription = subscription_on_comments(user) 
      subscription = commentable_subscriptions.where{user_id == user.id}.build
    end
    subscription
  end

  # Subscribe a user for comments
  def subscribe_to_comments user
    subscription = find_or_build_comment_subscription user
    subscription.subscribed = true
    subscription.save!
  end

  # Subscribe a user for comments only if there
  # is no subscription object
  def subscribe_to_comments_if_unset user
    subscription = subscription_on_comments user
    unless subscription
      subscription = build_comment_subscription user
      subscription.subscribed = true
      subscription.save!
    end
  end

  # Unsubscribe a user for comments. Does not delete
  # the subscription object
  def unsubscribe_from_comments user
    subscription = find_or_build_comment_subscription user
    subscription.subscribed = false
    subscription.save!
  end

  # Toggles the subscription state for the user
  def toggle_comment_subscription user
    subscription = find_or_build_comment_subscription user
    subscription.subscribed = !subscription.subscribed 
    subscription.save!
  end

end
