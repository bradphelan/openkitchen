# == Schema Information
#
# Table name: resources
#
#  id         :integer         primary key
#  name       :string(255)
#  quantity   :integer
#  units      :string(255)
#  event_id   :integer
#  created_at :timestamp
#  updated_at :timestamp
#

require 'spec_helper'

describe Resource do
  pending "add some examples to (or delete) #{__FILE__}"
end
