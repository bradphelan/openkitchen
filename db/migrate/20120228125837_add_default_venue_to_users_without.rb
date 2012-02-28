class Venue < ActiveRecord::Base
  has_many :user_venue_managements, :dependent => :destroy
  has_many :managers, :through => :user_venue_managements, :source => :manager, :class_name => "User"
end

class UserVenueManagement < ActiveRecord::Base
  belongs_to :manager, :foreign_key => :user_id, :class_name => "User" 
  belongs_to :venue
end

class User < ActiveRecord::Base
  has_many :user_venue_managements, :dependent => :destroy
  has_many :venues, :through => :user_venue_managements
end


class AddDefaultVenueToUsersWithout < ActiveRecord::Migration
  def change
    users = User.joins{user_venue_managements.outer}.where{user_venue_managements.id == nil}.all

    users.each do |u|
      say "Adding a kitchen for #{u.email}"
      v = Venue.create!
      v.user_venue_managements.create!(:manager => u, :role => :owner)
    end
    
  end
end
