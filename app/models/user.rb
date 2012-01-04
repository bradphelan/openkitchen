class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :events_as_owner, :class_name => "Event", :inverse_of => :owner, :foreign_key => :owner_id
  has_many :events_as_guest, :class_name => "Event", :inverse_of => :guests

end
