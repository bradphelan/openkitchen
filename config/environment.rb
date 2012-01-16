# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Gobbq::Application.initialize!

Gobbq::Application.config.action_mailer.smtp_settings = YAML.load(ERB.new(File.read("#{Rails.root}/config/mail.yml")).result)[Rails.env]
    
