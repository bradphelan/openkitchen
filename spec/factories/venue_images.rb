# == Schema Information
#
# Table name: venue_images
#
#  id                  :integer         not null, primary key
#  venue_id            :integer
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :venue_image do
  end
end
