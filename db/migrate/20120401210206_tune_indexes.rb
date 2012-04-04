class TuneIndexes < ActiveRecord::Migration
  def change
    remove_index "assets", :name => "by_id_and_type"
    add_index "assets", ["type", "id"], :name => "by_type_and_id"
  end

end
