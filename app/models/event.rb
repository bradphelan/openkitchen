# == Schema Information
#
# Table name: events
#
#  id          :integer         primary key
#  owner_id    :integer
#  created_at  :timestamp
#  updated_at  :timestamp
#  name        :string(255)
#  datetime    :timestamp
#  timezone    :string(255)
#  street      :string(255)
#  city        :string(255)
#  country     :string(255)
#  latitude    :float
#  longitude   :float
#  gmaps       :boolean
#  description :text
#

class Event < ActiveRecord::Base

  belongs_to :owner, :class_name => "User", :foreign_key => :owner_id

  has_many :invitations, :dependent => :destroy

  has_many :invitees, :through => :invitations, :source => :user

  has_many :resources, :dependent => :destroy

  attr_accessible  :name, :datetime, :timezone, :street, :city, :country, :description

  #skip_time_zone_conversion_for_attributes = [ :datetime ]
    

  acts_as_commentable

  validates_presence_of :timezone, :name, :datetime

  validates_length_of :name, :maximum => 80

  validates_length_of :street, :maximum => 80
  validates_length_of :city, :maximum => 80
  validates_length_of :country, :maximum => 80

  validates_numericality_of :latitude, :allow_blank => true
  validates_numericality_of :longitude, :allow_blank => true
  validates_length_of :description, :maximum => 4096 # characters

  #
  # Ensure the date of the event is always in the
  # timezone of the event
  #
  # TODO test this code. Scary!
  #
  def self.convert_to_timezone tz, dt
    format = '%d/%m/%Y %l:%M %p'
    ActiveSupport::TimeZone[tz].parse dt.try(:strftime, format)
  end
  before_save do
    tz = timezone || "UTC"
    self[:datetime] = Event.convert_to_timezone tz, self[:datetime]
  end

  def datetime
    if self[:datetime]
      tz = timezone || "UTC"
      self[:datetime].in_time_zone(tz)
    end
  end

  def description_unsanitzed_html
    BlueCloth.new(description).to_html
  end

  def invited? user
      invitations.where{user_id==user.id}.count > 0
  end

  def gmaps4rails_address
  "#{self.street}, #{self.city}, #{self.country}" 
  end

  def map_location
   MapLocation.new :address => gmaps4rails_address
  end

  def google_maps_link
    "http://maps.google.com/maps?q=#{gmaps4rails_address.gsub /\s/, '+'}"
  end


  # Owner should be implicityly
  # invited
  after_create do
    invitation = invite owner.email
    invitation.status = "accepted"
    invitation.save!
  end


  # Returns the invitation
  # 
  # Guest can be a User object or an
  # email address
  def invite guest

    unless guest.instance_of? User

      email = guest

      unless guest = User.where(:email => email).first
        guest = User.create! :email => email, :password => SecureRandom.hex(16)
      end

    end

    # Don't invite twice
    unless invitation = self.invitations.where{user_id==my{guest.id}}.first
      invitation = Invitation.create! do |i|
       i.event = self
       i.user = guest
      end
      InviteMailer.invite_email(invitation).deliver
    end

    invitation

  end



  def format_date
    datetime.try(:strftime, Date::DATE_FORMATS[:default])
  end

  def format_time
    datetime.try(:strftime, Date::DATE_FORMATS[:time_default])
  end

  def format_datetime
    "#{format_date} #{format_time}"
  end


end
