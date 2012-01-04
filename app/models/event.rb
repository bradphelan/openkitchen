class Event < ActiveRecord::Base

  belongs_to :owner, :class_name => "User", :foreign_key => :owner_id

  has_many :invitations

  has_many :invitees, :through => :invitations, :source => :user

  # Returns the invitation
  def invite email
      # Squeel notation does not work!
      # See https://github.com/ernie/squeel/issues/93
      unless u = User.where(:email => email).first
        u = User.create! :email => email, :password => SecureRandom.hex(16)
      end
      self.invitees << u
      self.invitations.where{user_id==my{u.id}}.first
  end

end
