class Profile < ActiveRecord::Base
end

class User < ActiveRecord::Base
end


class CreateProfiles < ActiveRecord::Migration
  def up
    create_table :profiles do |t|
      t.references :user, :null => :false
      t.has_attached_file :avatar

      t.integer   :cookstars, :default => 1

      # Defaults for venue when creating an 
      # event
      t.string    :timezone, :default => "UTC", :null => false
      t.string    :street
      t.string    :city
      t.string    :country
      t.string    :postcode

      t.timestamps
    end

    User.includes(:profile).each do |u|
      unless u.profile
        say "Creating profile for #{u.email}"
        u.create_profile!
      end
    end

  end

  def down
    drop_table :profiles
  end
end
