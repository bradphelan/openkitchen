if Rails.env.production?
  OmniAuth.config.full_host = "http://production.openkitchen.at"
elsif Rails.env.staging?
  OmniAuth.config.full_host = "http://staging.openkitchen.at"
elsif Rails.env.test?
  OmniAuth.config.full_host = "http://localhost.openkitchen.at"
elsif Rails.env.development?
  OmniAuth.config.full_host = "http://localhost.openkitchen.at"
end
