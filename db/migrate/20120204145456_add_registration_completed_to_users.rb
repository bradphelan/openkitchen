class AddRegistrationCompletedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :registration_completed_at, :timestamp
  end
end
