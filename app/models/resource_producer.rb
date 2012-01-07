class ResourceProducer < ActiveRecord::Base
  belongs_to :invitation
  belongs_to :resource
end
