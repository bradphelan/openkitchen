class AddVenueAsForeignKeyToEvent < ActiveRecord::Migration
  def change
    remove_column :events, :venue 
    add_column :events, :venue_id, :integer 
    add_index :events, :venue_id
  end
end
