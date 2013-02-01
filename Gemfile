source 'http://rubygems.org'

gem 'rails', '3.2.11'
gem 'will_paginate'
gem 'bootstrap-sass', '2.1'
gem 'bcrypt-ruby'
gem 'faker'
gem 'bootstrap-will_paginate'

# need this for therubyracer
gem 'libv8', '~> 3.11.8'

# Asset pipeline stuff for 3.2.5+
group :assets do
  gem 'sass-rails', '3.2.5'
  gem 'coffee-rails', '3.2.2'
  gem 'therubyracer', :platform => :ruby 
  gem 'execjs'
  gem 'uglifier', '1.2.3'
end

gem 'jquery-rails', '2.0.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'aws-s3', :require => 'aws/s3'
gem 'gravatar_image_tag'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

group :development, :test do
  gem 'sqlite3', '1.3.5'
  gem "rspec-rails", ">= 2.0.1"
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

group :test do
  gem 'cucumber-rails', require: false
end

group :production do
  gem 'pg', '0.12.2'
end
