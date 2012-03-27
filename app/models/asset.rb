class Asset < ActiveRecord::Base
  belongs_to :assetable, :polymorphic => true
  delegate :url, :to => :attachment
  delegate :expiring_url, :to => :attachment

  validates_attachment_presence :attachment

  attr_accessible :attachment

  DeleteAssetQueue = LazyWorkQueue.define :delete_asset_queue, :size => 1 do |info|
    Asset.where{terminated==true}.destroy_all
  end

  def background_destroy
    self.terminated = true
    self.save!
    after_transaction do
      DeleteAssetQueue.push ({})
    end
  end


end
