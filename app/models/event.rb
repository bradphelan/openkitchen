# == Schema Information
#
# Table name: events
#
#  id          :integer         not null, primary key
#  owner_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string(255)
#  datetime    :datetime
#  timezone    :string(255)
#  description :text
#  venue_id    :integer
#

class Event < ActiveRecord::Base

  belongs_to :owner, :class_name => "User", :foreign_key => :owner_id

  belongs_to :venue
  validates_presence_of :venue

  # Ensure the user can only add venues they own
  validates_inclusion_of :venue, :in => lambda { |e|
    e.owner.venues
  }

  has_many :invitations, :dependent => :destroy

  has_many :invitees, :through => :invitations, :source => :user

  has_many :resources, :dependent => :destroy

  attr_accessible  :name, :venue_id, :description, :timezone, :datetime, :public

  acts_as_commentable

  validates_presence_of :timezone, :name, :datetime

  validates_length_of :name, :maximum => 80

  validates_length_of :description, :maximum => 4096 # characters

  validates_presence_of :owner

  validates_inclusion_of :public, :in => [true, false]

  # Get the invitation to this event for
  # the specific user or nil if they are
  # not invited
  def invitation_for_user user
    invitations.where{user_id==user.id}.first
  end

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

  def invited? user
      invitations.where{user_id==user.id}.count > 0
  end

  # Owner should be implicityly
  # invited
  after_create do
    invitation = invite owner.email
    invitation.comment_subscription_state = "subscribed"
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
