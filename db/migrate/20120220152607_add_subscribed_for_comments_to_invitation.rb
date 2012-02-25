class AddSubscribedForCommentsToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :comment_subscription_state, :string, :default => "auto"
  end
end
