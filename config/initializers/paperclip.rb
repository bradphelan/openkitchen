
yml = File.join Rails.root, "config", "paperclip.yml"
options = YAML.load(ERB.new(File.read(yml)).result)[Rails.env]
Paperclip::Attachment.default_options.update options.symbolize_keys!

require 'pp'
pp Paperclip::Attachment.default_options
