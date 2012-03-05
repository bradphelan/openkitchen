if Rails.env.production?
  OmniAuth.config.full_host = "http://openkitchen.at"
elsif Rails.env.test?
  OmniAuth.config.full_host = "http://staging.openkitchen.at"
elsif Rails.env.development?
  OmniAuth.config.full_host = "http://localhost.openkitchen.at"
end
