# == Schema Information
#
# Table name: assets
#
#  id                      :integer         not null, primary key
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  created_at              :datetime        not null
#  updated_at              :datetime        not null
#  type                    :string(255)
#  attachment_processing   :boolean
#  terminated              :boolean         default(FALSE)
#

class Asset < ActiveRecord::Base
  belongs_to :assetable, :polymorphic => true
  delegate :url, :to => :attachment
  delegate :expiring_url, :to => :attachment
  delegate :present?, :to => :attachment

  validates_attachment_presence :attachment

  has_many :assetable_assets, :dependent => :destroy
  has_many :assetables, :through => :assetable_assets, :as => :assetable

  DeleteAssetQueue = LazyWorkQueue.define :delete_asset_queue, :size => 1 do |info|
    Asset.where{terminated==true}.destroy_all
  end

  if Rails.env.development?
    username = `whoami`.chomp
    AssetPath = ":rails_env-#{username}/assets/:id/:style.:extension"
  else
    AssetPath = ":rails_env/assets/:id/:style.:extension"
  end

  def self.configure_attachment options = {}
    options.merge! :path => AssetPath
    has_attached_file :attachment, options
    process_in_background :attachment
  end

  def background_destroy
    self.terminated = true
    self.save!
    after_transaction do
      DeleteAssetQueue.push ({})
    end
  end


end
