class AddTerminatedFieldToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :terminated, :boolean, :default => false
    add_index :assets, [:terminated]
  end
end
