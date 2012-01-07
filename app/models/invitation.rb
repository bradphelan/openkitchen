class Invitation < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  def self.generate_token
    SecureRandom.hex(32)
  end

  def self.generate_unique_token

    token = generate_token
    while where{token==my{token}}.count > 0
      token = generate_token
    end
    token
  end

  before_create do
    self.token = Invitation.generate_unique_token
  end

end
