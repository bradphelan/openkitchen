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


  validate :status, :inclusion => {
    :in => STATUSES
  }


  # Nothing is default setable
  attr_accessible 

  def self.generate_token
    SecureRandom.hex(32)
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
