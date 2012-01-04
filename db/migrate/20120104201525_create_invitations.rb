class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :event
      t.references :user

      t.timestamps
    end
  end
end
