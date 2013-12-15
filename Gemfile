source 'https://rubygems.org'
source 'https://rails-assets.org'

ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use pg as the database for Active Record
gem 'pg'

# ElasticSearch
gem 'tire'

# General requirements
gem 'awesome_print'
gem 'groupdate'
gem 'rdiscount'

gem 'devise'
gem 'omniauth'
gem 'omniauth-github'

# Model Dependenciies
gem 'nilify_blanks'
gem 'active_model_serializers'
gem 'validates_timeliness', github: 'softace/validates_timeliness', branch: 'support_for_rails4'
gem 'ranked-model'
gem 'acts-as-taggable-on'

gem 'figaro'

# View stuff
gem 'slim'
gem 'simple_form'
gem 'country_select'
gem "combined_time_select", "~> 1.0.0"

gem 'sass-rails'
gem 'rails-assets-bootstrap'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
gem 'capistrano', group: :development

# Development and test
group :test, :development do
  gem 'debugger'

  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false

  gem 'faker'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'rspec-rails'
  #gem 'capybara'
  gem 'guard-rspec'
  #gem 'guard-cucumber'
end

