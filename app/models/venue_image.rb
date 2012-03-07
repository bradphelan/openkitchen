# == Schema Information
#
# Table name: venue_images
#
#  id                 :integer         not null, primary key
#  venue_id           :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

class VenueImage < ActiveRecord::Base

  belongs_to :venue

  has_attached_file :image, 
    :styles => { :large => "1200x900#", :medium => "800x600#", :thumb=> "100x100#" }

  validates_attachment_presence :image

  validates_attachment_content_type :image, 
    :content_type => %r{image/.*}, 
    :less_than => 1.megabyte

  attr_accessible :image

end
