# == Schema Information
#
# Table name: venues
#
#  id          :integer         not null, primary key
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  name        :string(255)
#  timezone    :string(255)
#  street      :string(255)
#  city        :string(255)
#  country     :string(255)
#  postcode    :string(255)
#  latitude    :float
#  longitude   :float
#  gmaps       :boolean
#  description :text            default("")
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :venue do
    name { Forgery::Name.location }
    timezone {  Forgery::Time.zone }
    street { Forgery::Address.street_name }
    city { Forgery::Address.city }
    country { Forgery::Address.country }
    postcode { Forgery::Address.zip }
  end
end
