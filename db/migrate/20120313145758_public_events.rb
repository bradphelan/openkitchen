class PublicEvents < ActiveRecord::Migration
  def change
    add_column :events, :public_seats, :integer, :default => 0
    add_column :events, :automatic_public_invitation_approval, :boolean, :default => false


    add_column :invitations, :public, :boolean, :default => false
    add_column :invitations, :public_approved, :boolean, :default => false
  end

end
