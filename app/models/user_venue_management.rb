# == Schema Information
#
# Table name: user_venue_managements
#
#  id       :integer         not null, primary key
#  user_id  :integer
#  venue_id :integer
#  role     :string(255)
#

class UserVenueManagement < ActiveRecord::Base
  belongs_to :manager, :foreign_key => :user_id, :class_name => "User" 
  belongs_to :venue
end
