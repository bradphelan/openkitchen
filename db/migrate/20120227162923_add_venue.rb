class AddVenue < ActiveRecord::Migration
  def change
    add_column :profiles, :venue, :string
    add_column :events, :venue, :string
  end
end
