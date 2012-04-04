# == Schema Information
#
# Table name: assets
#
#  id                      :integer         not null, primary key
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  created_at              :datetime        not null
#  updated_at              :datetime        not null
#  type                    :string(255)
#  attachment_processing   :boolean
#  terminated              :boolean         default(FALSE)
#

require 'delayed_paperclip/jobs/girl_friday'

class ImageAsset < Asset

  configure_attachment styles: ImageSizes.standard_sizes_hash

  validates_attachment_content_type :attachment, 
    :content_type => %r{image/.*}, 
    :less_than => 5.megabyte

end
