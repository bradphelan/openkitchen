class Venue < ActiveRecord::Base
end

class UserVenueManagement < ActiveRecord::Base
  belongs_to :manager, :foreign_key => :user_id, :class_name => "User" 
  belongs_to :venue
end

class User < ActiveRecord::Base
  has_many :user_venue_management
  has_many :venues, :through => :user_venue_managements
end

class Event < ActiveRecord::Base
  belongs_to :owner, :class_name => "User", :foreign_key => :owner_id
  belongs_to :venue
end

class GiveDefaultVenueAName < ActiveRecord::Migration
  def up
    
    # Give all venues a default venue
    Venue.all.each do |v|
      unless v.name
        v.name = "My Kitchen"
        v.save!
      end
    end

    # Give all events a default venue
    Event.all.each do |e|
      unless e.venue_id
        v = e.owner.venues.first
        e.venue = v
        say "Giving event #{e.name} a venue #{v.name}"
        e.save!
      end
    end
  end

end
