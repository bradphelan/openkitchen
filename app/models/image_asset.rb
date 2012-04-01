require 'delayed_paperclip/jobs/girl_friday'

class ImageAsset < Asset

  configure_attachment styles: ImageSizes.standard_sizes_hash

  validates_attachment_content_type :attachment, 
    :content_type => %r{image/.*}, 
    :less_than => 5.megabyte

end
