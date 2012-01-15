class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :events_as_owner, :class_name => "Event", :inverse_of => :owner, :foreign_key => :owner_id, :dependent => :destroy
  has_many :events_as_guest, :through => :invitations, :source => :event

  has_many :invitations, :dependent => :destroy

  def name
    email
  end

  # TODO make this a configurable property
  def time_zone
    "Melbourne"
  end

end
