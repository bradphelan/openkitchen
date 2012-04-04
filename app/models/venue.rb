# == Schema Information
#
# Table name: venues
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  name       :string(255)
#  timezone   :string(255)
#  street     :string(255)
#  city       :string(255)
#  country    :string(255)
#  postcode   :string(255)
#  latitude   :float
#  longitude  :float
#  gmaps      :boolean
#

class Venue < ActiveRecord::Base
  attr_accessible :venue_images_attributes, :name, :description, :street, :city, :country, :timezone, :postcode

  has_many :user_venue_managements, :dependent => :destroy
  has_many :managers, :through => :user_venue_managements, :source => :manager, :class_name => "User"

  has_many :events

  validates_length_of :name, :maximum => 24, :minimum => 2
  validates_length_of :street, :maximum => 80
  validates_length_of :city, :maximum => 80
  validates_length_of :country, :maximum => 80
  validates_length_of :country, :maximum => 20
  validates_length_of :description, :maximum => 4096 # characters

  validates_numericality_of :latitude, :allow_blank => true
  validates_numericality_of :longitude, :allow_blank => true

  has_many :assetable_assets, :as => :assetable, :dependent => :destroy
  has_many :venue_images, :source => :asset, :through => :assetable_assets, :class_name => "ImageAsset"

  accepts_nested_attributes_for :venue_images, :allow_destroy => true
  attr_accessible :venue_images
    
  geocoded_by :full_address
  after_validation :geocode

  def full_address
    [self.street, self.city, self.country].reject {|e| e.nil? || e.blank?}.join ", "
  end

  def map_location
   MapLocation.new :address => full_address
  end

  def google_maps_link
    "http://maps.google.com/maps?q=#{full_address.gsub /\s/, '+'}"
  end
end
