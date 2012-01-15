class Resource < ActiveRecord::Base
  belongs_to :event
  has_many :resource_producers

  attr_accessible :name, :quantity, :units

  def quantity
    self[:quantity] || 0
  end

  def quantity_remaining_to_be_allocated
    quantity - quantity_produced
  end

  def quantity_produced
    resource_producers.inject(0) do |s, v|
      v.quantity + s
    end || 0
  end

  def quantity_produced_by invitation
    resource_producers.where{invitation_id==my{invitation.id}}.inject(0) do |s, v|
      v.quantity + s
    end || 0
  end

end
