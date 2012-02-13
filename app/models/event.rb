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

  acts_as_gmappable

  #acts_as_commentable

  def description_unsanitzed_html
    BlueCloth.new(description).to_html
  end

  def gmaps4rails_address
  "#{self.street}, #{self.city}, #{self.country}" 
  end

  def google_maps_link
    "http://maps.google.com/maps?q=#{gmaps4rails_address.gsub /\s/, '+'}"
  end

  def datetime
    self[:datetime].in_time_zone timezone
  end

  # Owner should be implicityly
  # invited
  after_create do
    invitation = invite owner.email
    invitation.status = "accepted"
    invitation.save!
  end


  # Returns the invitation
  def invite email

      # Squeel notation does not work!
      # See https://github.com/ernie/squeel/issues/93
      unless u = User.where(:email => email).first
        u = User.create! :email => email, :password => SecureRandom.hex(16)
      end

      invitation = self.invitations.where{user_id==my{u.id}}.first

      # Don't invite twice
      unless invitation
        self.invitees << u
        invitation = self.invitations.where{user_id==my{u.id}}.first
        InviteMailer.invite_email(invitation).deliver
      end

      invitation

  end


  def format_date
    datetime.try(:strftime, Date::DATE_FORMATS[:default])
  end

  def number_of_half_hour_intervals_since_midnight
    datetime.seconds_since_midnight / 60 / 30
  end

  def time
    datetime.to_time
  end

end
