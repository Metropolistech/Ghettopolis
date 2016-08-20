source 'https://rubygems.org'

ruby "2.2.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use postgresql
gem 'pg'

# Use Rspec for test
gem 'rspec'
gem 'rspec-rails', '~> 3.0'
gem 'database_cleaner'

# Authentication
gem 'jwt'
gem 'devise'
gem 'rack-cors', require: 'rack/cors'

# Tags
gem 'acts-as-taggable-on', '~> 3.4'

# AWS bucket S3
gem 'aws-sdk', '~> 2'

# Pagination
gem 'will_paginate', '~> 3.1.0'

group :test do
  # Code coverage gem
  gem 'simplecov', :require => false
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Gem to have nyan cat color when the tests are running
  gem 'nyan-cat-formatter'
  # Get environement variables from .env file
  gem 'dotenv-rails'
  # Using shloud matchers to test models
  gem 'shoulda-matchers', '~> 3.1'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Have better logs in heroku with Rails
gem 'rails_12factor', group: :production
