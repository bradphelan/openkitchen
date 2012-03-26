class AddPolymorphicAssetsTable < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.references :assetable, :polymorphic => true
      t.has_attached_file :attachment
      t.timestamps
    end
  end

end
