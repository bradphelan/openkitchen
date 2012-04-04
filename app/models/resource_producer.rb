# == Schema Information
#
# Table name: resource_producers
#
#  id            :integer         not null, primary key
#  invitation_id :integer
#  resource_id   :integer
#  quantity      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class ResourceProducer < ActiveRecord::Base
  belongs_to :invitation
  belongs_to :resource

  attr_accessible :quantity

  def quantity
    self[:quantity] || 0
  end
end
