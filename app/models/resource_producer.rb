class ResourceProducer < ActiveRecord::Base
  belongs_to :invitation
  belongs_to :resource

  attr_accessible :quantity

  def quantity
    self[:quantity] || 0
  end
end
