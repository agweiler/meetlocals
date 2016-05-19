source 'https://rubygems.org'

ruby "2.3.0"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
gem "therubyracer"
gem "twitter-bootstrap-rails"
gem "less-rails"
gem 'bootstrap-sass', '3.2.0'
gem 'autoprefixer-rails'
gem 'paypal-sdk-adaptivepayments'
gem 'stripe'
# Use pg as the database for Active Record
gem 'pg'
# memory profiler
gem 'rack-mini-profiler'
gem 'flamegraph'
gem 'stackprof' # ruby 2.1+ only
gem 'memory_profiler'
gem 'cocoon'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'puma'
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'aws-sdk', '< 2.0'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# #added jquery-tubolinks gem so javascript code loads at the first time, before this need to refresh page
# gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'sidekiq'
gem 'redis'
gem 'minitest', '~> 5.5.1'
#gem used for ratingbundle i
gem 'ratyrate'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'devise'
# gem 'devise-async', git: "git://github.com/hewrin/devise-async.git"
gem "paperclip", "~> 4.2"

# gem 'momentjs-rails', '>= 2.9.0'
# gem 'bootstrap3-datetimepicker-rails', '~> 4.0.0'

# gem 'mailchimp-api', require: 'mailchimp'
gem 'gibbon', git: 'git://github.com/amro/gibbon.git'
# gem 'font-awesome-sass', '~> 4.3.0'
# gem 'font-awesome-rails'

gem 'bootstrap-wysihtml5-rails', github: 'nerian/bootstrap-wysihtml5-rails'

gem 'will_paginate'
gem 'bootstrap-will_paginate'

gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

gem 'sinatra', :require => nil
gem 'delayed_paperclip', git: "git://github.com/hewrin/delayed_paperclip.git"

gem 'newrelic_rpm'

gem "bullet", :group => "development"

gem 'sanitize'

gem 'filterrific'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring' # I had to update the gemfile.lock
end

group :test do
	gem 'capybara'
	gem 'guard-rspec'
	gem 'launchy'
  gem 'shoulda-matchers', '~> 2.8.0'
end


gem 'rails_12factor', group: :production
