class Asset < ActiveRecord::Base
  belongs_to :assetable, :polymorphic => true
  delegate :url, :to => :attachment
  delegate :expiring_url, :to => :attachment

  validates_attachment_presence :attachment

  attr_accessible :attachment
end
