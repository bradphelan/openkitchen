class AddPublicFlagToEvent < ActiveRecord::Migration
  def change
    add_column :events, :public, :boolean, :default => false, :null => false
  end
end
