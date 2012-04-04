# == Schema Information
#
# Table name: resource_producers
#
#  id            :integer         not null, primary key
#  invitation_id :integer
#  resource_id   :integer
#  quantity      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe ResourceProducer do
  pending "add some examples to (or delete) #{__FILE__}"
end
