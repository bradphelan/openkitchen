# == Schema Information
#
# Table name: venues
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  name       :string(255)
#  timezone   :string(255)
#  street     :string(255)
#  city       :string(255)
#  country    :string(255)
#  postcode   :string(255)
#  latitude   :float
#  longitude  :float
#  gmaps      :boolean
#

require 'spec_helper'

describe Venue do
  pending "add some examples to (or delete) #{__FILE__}"
end
