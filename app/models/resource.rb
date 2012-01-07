class Resource < ActiveRecord::Base
  belongs_to :event
  has_many :resource_producers

  def quantity_produced
    resource_producers.inject(0) do |s, v|
      v.quantity + s
    end
  end

  def quantity_produced_by invitation
    resource_producers.where{invitation_id==my{invitation.id}}.inject(0) do |s, v|
      v.quantity + s
    end
  end

end
