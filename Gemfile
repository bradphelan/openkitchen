
source 'http://rubygems.org'

gem 'rails', '~> 3.2.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

group :test, :development do
  gem 'hpricot'
  gem 'ruby_parser'
  gem 'steak'
  #gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'rspec-example_steps'
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'heroku_san'
  
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails'
  gem 'uglifier', '>= 1.0.3'
  gem 'sass-rails', '~> 3.1'
  #gem 'bootstrap-sass', '~> 2.0.0'
  gem 'bootstrap-sass', :git => "https://github.com/thomas-mcdonald/bootstrap-sass.git", :branch => "2.0.2"
  
end

#gem 'sass-rails',   '~> 3.1.5'

gem 'formtastic', :git => 'https://github.com/justinfrench/formtastic.git' 
gem 'formtastic-bootstrap', :git => 'https://github.com/cgunther/formtastic-bootstrap.git', :branch => "2.0"

gem "cancan"
gem "inherited_resources"

# gem "compass", '0.12.alpha.4'
# gem "compass-bootstrap"
# gem "compass-susy-plugin", :require => "susy"
gem "bluecloth" # markdown filter for haml



# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
gem 'unicorn'
gem 'foreman'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem "rspec-rails", ">= 2.0.1", :group => [:development, :test]
gem "capybara", :group => [:development, :test]
gem "devise"
gem "koala"
gem "haml", ">= 3.0.0"
gem "haml-rails"
gem "jquery-rails"
gem "underscore-rails"
gem "squeel"
gem "apotomo"

gem "heroku"
#gem "activeadmin"

group :test do
  gem "shoulda-matchers"
  gem "rspec-apotomo"
end

group :test, :development do
  gem "forgery"
  gem "factory_girl_rails"
end

group :development do
  gem 'lunchy' # Process controll
end
gem "pg"

gem "omniauth-facebook"


gem 'vimeo'

gem 'acts_as_commentable_with_threading', :git => 'https://github.com/elight/acts_as_commentable_with_threading.git'

gem 'paperclip'
gem 'aws-sdk'

gem 'icalendar'

gem "girl_friday", "~> 0.9.7"

gem "rails-i18n"
gem "devise-i18n"

gem "newrelic_rpm"

gem "ar_after_transaction"

gem "pusher_rails"

# Geocoding Gems
gem "geocoder"
gem 'googlestaticmap'

gem 'remotipart'

# Use git until 
# https://github.com/jstorimer/delayed_paperclip/pull/62
# is merged
gem 'delayed_paperclip', :git => 'https://github.com/tommeier/delayed_paperclip.git', :branch => 'fix_27_cleaned'
