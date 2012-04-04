# == Schema Information
#
# Table name: assetable_assets
#
#  id             :integer         not null, primary key
#  assetable_id   :integer
#  assetable_type :string(255)
#  asset_id       :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class AssetableAsset < ActiveRecord::Base
  belongs_to :assetable, :polymorphic => true
  belongs_to :asset

  # Clean up orphans
  before_destroy do
    if not asset.nil?
      if asset.assetable_assets.count == 1
        asset.background_destroy
      end
    end
  end
end
