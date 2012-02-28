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
#  timezone            :string(255)
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

require 'spec_helper'

describe Profile do
  pending "add some examples to (or delete) #{__FILE__}"
end
