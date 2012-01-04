class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :owner # user

      t.timestamps
    end
  end
end
