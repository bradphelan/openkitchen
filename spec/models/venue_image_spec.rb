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

require 'spec_helper'

describe VenueImage do
  pending "add some examples to (or delete) #{__FILE__}"
end