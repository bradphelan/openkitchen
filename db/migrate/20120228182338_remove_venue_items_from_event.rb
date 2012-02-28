class RemoveVenueItemsFromEvent < ActiveRecord::Migration
  def change
    cols = %w{
      street
      city
      country
      latitude
      longitude
      gmaps
    }

    cols.each do |col|
      remove_column :events, col.to_sym
    end

    add_column :venues, :latitude, :float
    add_column :venues, :longitude, :float
    add_column :venues, :gmaps, :boolean

  end

end
