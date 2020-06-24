source 'http://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'bundler', '>= 1.8.4'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'mongoid'
gem 'enumerize'
gem 'seedbank', github: 'cuhappycorner/seedbank'
gem 'mongoid_token', github: 'cuhappycorner/mongoid_token'
gem 'money-rails'
gem 'kaminari'
gem 'slim'
gem 'slim-rails'
gem 'browser'
gem 'simple_form'
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'select2-rails'
gem 'sentry-raven'
gem 'sendgrid'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'sidekiq-statistic'
gem 'procodile', require: false
gem 'gemoji-parser'
gem 'typhoeus', platforms: [:ruby]
gem 'glip-poster'
gem 'gibbon'
gem 'rubocop', require: false
gem 'devise'
gem 'discourse_api'
gem 'doorkeeper-mongodb', github: 'cuhappycorner/doorkeeper-mongodb'
gem 'gravtastic'


source 'http://insecure.rails-assets.org' do
  gem 'rails-assets-modernizr', '2.8.3'
  gem 'rails-assets-twitter-bootstrap-wizard'
  gem 'rails-assets-jquery-validation'
  gem 'rails-assets-jquery.easing'
  gem 'rails-assets-unveil'
  gem 'rails-assets-jquery-bez'
  gem 'rails-assets-ioslist'
  gem 'rails-assets-jquery.actual'
  gem 'rails-assets-jquery.scrollbar'
  gem 'rails-assets-pace'
  gem 'rails-assets-classie'
  gem 'rails-assets-datatables'
  gem 'rails-assets-datatables-buttons'
  gem 'rails-assets-pdfmake'
  gem 'rails-assets-jszip'
  gem 'rails-assets-mailcheck'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'railroady'
end

group :development do
  gem 'derailed'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'brakeman',           require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
