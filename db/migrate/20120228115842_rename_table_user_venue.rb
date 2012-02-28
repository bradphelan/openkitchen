class RenameTableUserVenue < ActiveRecord::Migration
  def change
    rename_table :user_venue, :user_venue_managements
  end
end
