class Asset < ActiveRecord::Base
end
class ImageAsset < Asset
end

class AddAssetableAsset < ActiveRecord::Migration
  def change
    create_table :assetable_assets do |t|
      t.references :assetable, :polymorphic => true
      t.references :asset
      t.timestamps
    end
    add_index :assetable_assets, [:assetable_id, :assetable_type, :asset_id], 
     :unique => true, :name => "assetable_assets_link"

    remove_column :assets, :assetable_id
    remove_column :assets, :assetable_type
    #remove_index :assets, :name => :by_assetable_id_and_assetable_type

    Asset.destroy_all

  end

end
