class CreateVenueImages < ActiveRecord::Migration
  def change
    create_table :venue_images do |t|
      t.references :venue, :null => :false
      t.has_attached_file :image
      t.timestamps
    end
  end
end
