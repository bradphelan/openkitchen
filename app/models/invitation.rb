# == Schema Information
#
# Table name: invitations
#
#  id         :integer         not null, primary key
#  event_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  token      :string(255)
#  status     :string(255)     default("pending")
#

class Invitation < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :resource_producers, :dependent => :destroy

  attr_accessible :status

  STATUSES = %w(
    pending
    maybe
    accepted
    rejected
  )

  after_save do
    # If the invitation is rejected we delete all
    # the things we are bringing
    if rejected?
      resource_producers.destroy_all
    end
  end

  def pending?
    status == "pending"
  end

  def maybe?
    status == "maybe"
  end

  def accepted?
    status == "accepted"
  end

  def rejected?
    status == "rejected"
  end

  def subscribed_for_comments?
    true
  end


  validate :status, :inclusion => {
    :in => STATUSES
  }


  # Nothing is default setable
  attr_accessible 

  def self.generate_token
    # See http://stackoverflow.com/questions/7437944/sqlite3-varchar-matching-with-like-but-not for
    # why we need force_encoding
    SecureRandom.hex(32).force_encoding('UTF-8')
  end

  def self.generate_unique_token

    t= generate_token
    while where{token==my{t}}.count > 0
      t= generate_token
    end
    t
  end

  before_create do
    self.token = Invitation.generate_unique_token
  end

end
