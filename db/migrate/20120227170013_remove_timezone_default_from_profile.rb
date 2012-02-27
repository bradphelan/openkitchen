class RemoveTimezoneDefaultFromProfile < ActiveRecord::Migration
  def up
    change_column :profiles, :timezone, :string, :default => nil, :null => true
  end

  def down
    change_column :profiles, :timezone, :string, :default => "UTC", :null => false
  end
end
