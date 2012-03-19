# == Schema Information
#
# Table name: events
#
#  id                                   :integer         not null, primary key
#  owner_id                             :integer
#  created_at                           :datetime
#  updated_at                           :datetime
#  name                                 :string(255)
#  datetime                             :datetime
#  timezone                             :string(255)
#  description                          :text
#  venue_id                             :integer
#  public                               :boolean         default(FALSE), not null
#  public_seats                         :integer         default(0)
#  automatic_public_invitation_approval :boolean         default(FALSE)
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

  attr_accessible  :public_seats, :public, :name, :venue_id, :description, :timezone, :datetime

  def public_seats_left
    [0, public_seats - invitations.where{public==true}.count].max
  end

  acts_as_commentable

  validates_presence_of :timezone, :name, :datetime

  validates_length_of :name, :maximum => 80

  validates_length_of :description, :maximum => 4096 # characters

  validates_presence_of :owner

  #
  # Public event support
  #

  validates_inclusion_of :public, :in => [true, false]

  validates_numericality_of :public_seats, 
    :greater_than_or_equal_to => 0, 
    :only_integer => true

  validates_inclusion_of :automatic_public_invitation_approval, :in => [true, false]

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
    invitation = invite owner
    invitation.comment_subscription_state = "subscribed"
    invitation.status = "accepted"
    invitation.save!
  end

  def self.future_events
    where{datetime > Time.zone.now}
  end

  def self.near location, radius_km
    venues = Venue.near(location, radius_km).map &:id
    joins{venue}.where{venue.id.in venues}.future_events
  end


  def invited? user
    if user
      invitations.where{user_id==user.id}.count > 0
    end
  end

  # Returns the invitation
  # 
  # Guest can be a User object or an
  # email address
  def invite guest, options = {}

    as_public = options.delete :public
    status    = options.delete :status

    # Don't invite twice
    unless invitation = self.invitations.where{user_id==my{guest.id}}.first
      invitation = Invitation.create! do |i|
       i.event = self
       i.user = guest
       i.public = as_public if as_public
       i.public_approved = as_public if as_public
       i.status = status if status
      end
      InviteMailer.deliver_invitation(invitation)
    end

    invitation

  end

  def format_date
    datetime.try(:strftime, Date::DATE_FORMATS[:textual])
  end

  def format_time
    datetime.try(:strftime, Date::DATE_FORMATS[:time_default])
  end

  def format_datetime
    "#{format_date} #{format_time}"
  end

end
