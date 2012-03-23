class CommentableSubscription < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  validates_inclusion_of :subscribed, :in => [true, false]
end
