class Add < ActiveRecord::Migration
  def change
    add_column :users, :about, :text, :default => ""
  end

end
