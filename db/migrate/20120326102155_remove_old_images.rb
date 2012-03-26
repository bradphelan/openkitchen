ImageStyles = { :vlarge => "1200x900", 
  :large => "1024x768",
  :medium => "800x600",
  :small => "380x280", 
  :thumb=> "100x100#",
  :minithumb => "50x50#" }

class VenueImage < ActiveRecord::Base
  has_attached_file :image, 
    :styles => ImageStyles
end

class User < ActiveRecord::Base
  has_attached_file :avatar, 
    :styles => ImageStyles
end

class RemoveOldImages < ActiveRecord::Migration
  def up
    VenueImage.destroy_all
    User.all.each do |u|
      u.avatar.destroy
    end
    drop_table :venue_images
  end
end
