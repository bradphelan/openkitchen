class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string   :name
      t.integer  :quantity
      t.string   :units
      t.references :event
      t.timestamps
    end
  end
end
