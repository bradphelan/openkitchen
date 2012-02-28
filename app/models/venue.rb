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
  attr_accessible :name, :street, :city, :country, :timezone, :postcode

  has_many :user_venue_managements, :dependent => :destroy
  has_many :managers, :through => :user_venue_managements, :source => :manager, :class_name => "User"

  has_many :events

  validates_length_of :street, :maximum => 80
  validates_length_of :city, :maximum => 80
  validates_length_of :country, :maximum => 80
  validates_length_of :country, :maximum => 20

  validates_numericality_of :latitude, :allow_blank => true
  validates_numericality_of :longitude, :allow_blank => true
    
  def gmaps4rails_address
  "#{self.street}, #{self.city}, #{self.country}" 
  end

  def map_location
   MapLocation.new :address => gmaps4rails_address
  end

  def google_maps_link
    "http://maps.google.com/maps?q=#{gmaps4rails_address.gsub /\s/, '+'}"
  end
end
