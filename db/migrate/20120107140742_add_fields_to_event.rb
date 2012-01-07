class AddFieldsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :name, :string
    add_column :events, :datetime, :datetime
    add_column :events, :timezone, :string
  end
end
