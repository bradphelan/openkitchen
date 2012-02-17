Paperclip.options[:url] = "/system/:class/:attachment/:id/:basename-:style.:extension"
Paperclip.options[:s3_credentials] = {
          :access_key_id => ENV['S3_KEY'],
          :secret_access_key => ENV['S3_SECRET']
        }
