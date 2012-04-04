# == Schema Information
#
# Table name: commentable_subscriptions
#
#  id               :integer         not null, primary key
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  subscribed       :boolean
#

class CommentableSubscription < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  validates_inclusion_of :subscribed, :in => [true, false]
end
