class ImageAsset < Asset

  has_attached_file :attachment, 
    :styles => ImageSizes.standard_sizes_hash

  validates_attachment_content_type :attachment, 
    :content_type => %r{image/.*}, 
    :less_than => 1.megabyte

end
