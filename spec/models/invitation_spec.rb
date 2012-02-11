# == Schema Information
#
# Table name: invitations
#
#  id         :integer         not null, primary key
#  event_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  token      :string(255)
#  status     :string(255)     default("pending")
#

require 'spec_helper'

describe Invitation do
  pending "add some examples to (or delete) #{__FILE__}"
end
