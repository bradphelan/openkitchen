class AddAcceptedToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :status, :string, :default => "pending"
  end
end
