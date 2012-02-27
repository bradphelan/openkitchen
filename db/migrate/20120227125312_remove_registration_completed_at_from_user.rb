class User < ActiveRecord::Base
end

class RemoveRegistrationCompletedAtFromUser < ActiveRecord::Migration
  def up

    User.all.each do |u|
      if u.registration_completed_at
        u.confirmed_at = u.registration_completed_at
        u.save!
      end
    end

    remove_column :users, :registration_completed_at
  end

  def down
    add_column :users, :registration_completed_at, :datetime

    User.all.each do |u|
      if u.confirmed_at
        u.registration_completed_at = u.confirmed_at
        u.save!
      end
    end
  end
end
