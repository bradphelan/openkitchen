class AddInvitationsIndex < ActiveRecord::Migration
  def change
    add_index :invitations, [ :user_id, :event_id ], :unique => true, :name => 'by_user_and_event'
    add_index :invitations, [ :event_id ], :name => 'by_event'
    add_index :events, [ :owner_id], :name => 'by_owner'
  end
end
