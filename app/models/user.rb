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
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :events_as_owner, :class_name => "Event", :inverse_of => :owner, :foreign_key => :owner_id, :dependent => :destroy
  has_many :events_as_guest, :through => :invitations, :source => :event

  has_many :invitations, :dependent => :destroy

  has_one :profile, :dependent => :destroy
  after_create do
    self.create_profile!
  end

  # TODO Perhapps if the last manager of a venue is destroyed then
  # the venue should also be destroyed or it will be orphaned. This
  # will happen more often than not if the primary venue of the user
  # , being their kitchen is not deleted if the user account is.
  has_many :user_venue_managements, :dependent => :destroy

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
     v.role = :manager
     v.name = I18n.t('default_venue_name')
    end
  end


  def name
    email
  end

  # Return all my friends, ( being those who I have invited at least once to a party)
  def friends
    User.joins{events_as_guest}.where{events_as_guest.owner_id==my{id}}.where{users.id != my{id}}
  end

  def friends_emails
    friends.map &:email
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

end
