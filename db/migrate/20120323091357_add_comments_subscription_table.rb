class AddCommentsSubscriptionTable < ActiveRecord::Migration
  def change
    create_table :commentable_subscriptions do |t|
      t.references :commentable, :polymorphic => true
      t.references :user
      t.boolean :subscribed
    end

    remove_column :invitations, :comment_subscription_state
  end
end
