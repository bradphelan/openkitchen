class CreateResourceProducers < ActiveRecord::Migration
  def change
    create_table :resource_producers do |t|
      t.references :invitation
      t.references :resource
      t.integer :quantity

      t.timestamps
    end
  end
end
