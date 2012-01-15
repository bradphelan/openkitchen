class Invitation < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

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
