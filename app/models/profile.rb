# == Schema Information
#
# Table name: profiles
#
#  id                  :integer         not null, primary key
#  user_id             :integer
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  cookstars           :integer         default(1)
#  timezone            :string(255)     default("UTC"), not null
#  street              :string(255)
#  city                :string(255)
#  country             :string(255)
#  postcode            :string(255)
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

class Profile < ActiveRecord::Base
  belongs_to :user

  has_attached_file :avatar, :styles => { :medium => "300x300#", :thumb => "100x100#", :mini_thumb => "50x50#" }

  validates_presence_of :user_id
  validates_numericality_of :cookstars, 
    :only_integer => true,
    :greater_than_or_equal_to => 1,
    :less_than_or_equal_to => 5

  validates_length_of :street, :maximum => 80
  validates_length_of :city, :maximum => 80
  validates_length_of :country, :maximum => 80
  validates_length_of :country, :maximum => 20
    

  validates_attachment_content_type :avatar, 
    :content_type => %r{image/.*}, 
    :less_than => 1.megabyte

end
