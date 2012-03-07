class User < ActiveRecord::Base
end

class Profile < ActiveRecord::Base
end

class MoveProfileToUser < ActiveRecord::Migration
  def change 
    change_table :users do |t|
      t.has_attached_file :avatar
    end

    add_column :users, :cookstars, :integer, :default => 1
    add_column :users, :timezone, :string, :default => "UTC"

  end

  def down
  end
end
