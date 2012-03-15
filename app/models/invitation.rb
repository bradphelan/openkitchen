# == Schema Information
#
# Table name: invitations
#
#  id                         :integer         not null, primary key
#  event_id                   :integer
#  user_id                    :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#  token                      :string(255)
#  status                     :string(255)     default("pending")
#  comment_subscription_state :string(255)     default("auto")
#  public                     :boolean         default(FALSE)
#  public_approved            :boolean         default(FALSE)
#

class Invitation < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :resource_producers, :dependent => :destroy
  
  #
  # Public event support
  #
  
  # true if the invitation is a self registration
  # in response to a public event
  validates_inclusion_of :public,
    :in => [true, false]

  # true if the invitation has been approved by
  # the owner. Only meaningful in context of
  # #public? => true
  validates_inclusion_of :public_approved, 
    :in => [true, false]


  #
  #
  # COMMENT SUBSCRIPTIONS
  #
  #
  #

  COMMENT_SUBSCRIPTION_STATES = %w(
    auto
    subscribed
    unsubscribed
  )

  validates_inclusion_of :comment_subscription_state, :in => COMMENT_SUBSCRIPTION_STATES

  def subscribed_for_comments?
    comment_subscription_state == "subscribed"
  end

  def subscribe_for_comments!
    self.comment_subscription_state = 'subscribed'
    save!
  end

  def toggle_subscription!
    if self.comment_subscription_state == 'subscribed'
      self.comment_subscription_state = 'unsubscribed'
    else
      self.comment_subscription_state = 'subscribed'
    end
    save!
  end

  def unsubscribe_for_comments!
    self.comment_subscription_state = 'unsubscribed'
    save!
  end

  #
  # If the invitation has made a comment and the comment_subscription_state is
  # currently 'auto' then move it to 'subscribed' and save, otherwise do
  # nothing.
  def update_comment_subscription_state!
    if event.root_comments.for_user(user).count > 0 and comment_subscription_state == 'auto'
      subscribe_for_comments!
    end
  end

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
