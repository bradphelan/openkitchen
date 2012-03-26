class AddTypeFieldsToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :type, :string
    add_index :assets, [:id, :type], :name => 'by_id_and_type'
    add_index :assets, [:assetable_id, :assetable_type], :name => 'by_assetable_id_and_assetable_type'
  end
end
