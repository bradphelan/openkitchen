class Event < ActiveRecord::Base

  belongs_to :owner, :class_name => "User", :foreign_key => :owner_id

  has_many :invitations

  has_many :invitees, :through => :invitations, :source => :user

  def make_user_token email
    require 'digest/md5'
    # TODO salt the below digest
    Digest::MD5.hexdigest("#{id}-#{email}")
  end

  def invite email
      user = User.where{email==my{email}}.first
      unless user
        user = User.create! :email => email, :password => make_user_token(email)
      end
      self.invitees << user

  end

end
