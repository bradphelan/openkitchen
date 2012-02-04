class AddConfirmableToUsers < ActiveRecord::Migration
  def change
    ## Confirmable
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    # t.string   :unconfirmed_email # Only if using reconfirmable
    
  end
end
