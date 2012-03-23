# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  name                   :string(255)
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  cookstars              :integer         default(1)
#  timezone               :string(255)     default("UTC")
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :about, :name,  :password, :password_confirmation, :remember_me
  attr_accessible :cookstars, :avatar, :timezone

  has_many :events_as_owner, :class_name => "Event", :inverse_of => :owner, :foreign_key => :owner_id, :dependent => :destroy
  has_many :events_as_guest, :through => :invitations, :source => :event

  has_many :invitations, :dependent => :destroy

  # The people who I have been invited to an event with
  has_many :guest_peers,    :class_name => "User", :through => :events_as_guest, :source => :invitees, :uniq => true

  # The people who have invited me to an event
  has_many :event_hosts,    :class_name => "User", :through => :events_as_guest, :source => :owner, :uniq => true 

  # The people who I have invited to an event
  has_many :event_invitees, :class_name => "User", :through => :events_as_owner, :source => :invitees, :uniq => true

  # TODO Perhapps if the last manager of a venue is destroyed then
  # the venue should also be destroyed or it will be orphaned. This
  # will happen more often than not if the primary venue of the user
  # , being their kitchen is not deleted if the user account is.
  has_many :user_venue_managements, :dependent => :destroy

  # Delete commentable subscriptions when a user is deleted
  has_many :commentable_subscriptions, :dependent => :destroy

  has_many :venues, :through => :user_venue_managements do
    def create *params, &block
      UserVenueManagement.with_scope :create => { :role => :owner } do
        super *params, &block
      end
    end
    def create! *params, &block
      UserVenueManagement.with_scope :create => { :role => :owner } do
        super *params, &block
      end
    end
  end

  after_create do
    # We need at least one primary venue
    self.venues.create! do |v|
     v.name = I18n.t('default_venue_name')
    end
  end

  validates_length_of :name, :minimum => 3, :maximum => 80, :allow_blank => true

  validates_length_of :about, :maximum => 4096

  def name
    if self[:name]
      self[:name]
    else
      email.gsub /@.*$/, '@....'
    end
  end

  has_attached_file :avatar, 
    :styles => ImageSizes.standard_sizes_hash,
    :default_url => "/assets/chef.jpg"

  validates_attachment_content_type :avatar, 
    :content_type => %r{image/.*}, 
    :less_than => 1.megabyte

  validates_numericality_of :cookstars, 
    :only_integer => true,
    :greater_than_or_equal_to => 1,
    :less_than_or_equal_to => 5

  # Return all my friends, ( being those who I have invited at least once to a party)
  def friends


    components = []


    # Friends as guests
    components << guest_peers

    # Friends as hosts
    components << event_hosts

    # Friends as co-guests
    components << event_invitees

    # Combine all queries together as a disjunction over the above
    # components
    User.where do
      components.map { |c| id.in c.select{id} }.inject { |s,i| s | i }
    end


  end

  def friends_emails
    friends.map &:email
  end

  def invite_typeahead_data
    friends.map do |user|
      {
        :name => user.name,
        :id => user.id
      }
    end

  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    
    data = access_token.extra.raw_info
    token = access_token.credentials.token

    # -- facebook experiment. Kool it works !!
    @graph = Koala::Facebook::API.new(token)
    friends = @graph.get_connections("me", "friends")


    if user = User.where(:email => data.email).first
      user
    else # Create a user with a stub password. 
      User.create!(:email => data.email, :password => Devise.friendly_token[0,20]) 
    end
  end

  # TODO make this a configurable property
  def time_zone
    "Melbourne"
  end

  def password_match?
    self.errors[:password] << 'password not match' if password != password_confirmation
    self.errors[:password] << 'you must provide a password' if password.blank?
    password == password_confirmation and !password.blank?
  end

  def self.find_or_create_by_email email
    user = User.find_by_email email
    if not user
      user = User.create! :email => email, :password => SecureRandom.hex(16)
    end
    user
  end

end
