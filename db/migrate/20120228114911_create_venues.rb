class CreateVenues < ActiveRecord::Migration
  def change

    remove_column :profiles, :venue
    remove_column :profiles, :street
    remove_column :profiles, :city
    remove_column :profiles, :country
    remove_column :profiles, :postcode

    create_table :venues do |t|
      t.timestamps

      t.string   :name
      t.string   :timezone
      t.string   :street
      t.string   :city
      t.string   :country
      t.string   :postcode

    end

    create_table :user_venue do |t|
      t.references :user
      t.references :venue
      t.string :role
    end

  end
end
