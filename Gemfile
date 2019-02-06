source 'https://rubygems.org'

ruby '2.2.2'

# Use unicorn as the app server
gem 'unicorn'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1', '>= 5.1.3'
# Use sqlite3 as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
# gem 'sass-rails'
gem 'sass-rails', '~> 5.0', '>= 5.0.4'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# Haml is a templating engine for HTML
gem 'haml'

# using bootstrap 3 - flat UI
gem 'bootstrap-sass'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'turbolinks-source'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# The administration framework for Ruby on Rails.
# gem 'inherited_resources', github: 'josevalim/inherited_resources'
gem 'responders', '~> 2.0'
gem 'activeadmin', github: 'activeadmin'
gem 'inherited_resources', github: 'activeadmin/inherited_resources'

# Flexible authentication solution for Rails with Warden
gem 'devise'

# Raven is a Ruby client for Sentry
gem "sentry-raven"

# Authorization
gem 'cancancan'

# The Ruby cloud services library.
# gem 'fog'

# Manipulate images with minimal use of memory via ImageMagick / GraphicsMagick
# gem 'mini_magick'

# Upload files in your Ruby applications, map them to a range of ORMs, store them on different backends.
# gem "carrierwave"

gem 'newrelic_rpm'

# Makes http fun! Also, makes consuming restful web services dead easy.
gem 'httparty'

# Facebook OAuth2 Strategy for OmniAuth
gem 'omniauth-facebook'

# OmniAuth strategy for Twitter
gem 'omniauth-twitter'

# OmniAuth strategy for Instagram
gem 'omniauth-instagram'

# Static asset serving
gem 'rack-cors', :require => 'rack/cors'
gem 'font_assets'

# Start processes using the Procfile
gem 'foreman'

# the font-awesome font for the rails asset pipeline
gem 'font-awesome-rails'

# formtastic and simpleform
gem 'jasny_bootstrap_extension_rails'

# Multi threaded server for rails 5
gem 'puma'
# gem "unicorn"

# GitHub api ruby interface
gem "octokit", "~> 4.0"

# A simple HTTP and REST client for Ruby
gem 'rest-client', '~> 1.8'

# String colorize in console
gem 'colorize', '~> 0.8.1'

gem 'client_side_validations', '~> 9.3', '>= 9.3.3'
# skit_gems = ['sessions_facebook', 'sessions']

gem 'sidekiq'
gem "simple_scheduler"

gem 'activerecord-import', '>= 0.4.0'

gem "cocoon"

gem 'twilio-ruby', '~> 5.1.2'

gem 'redis', '~> 3.3', '>= 3.3.1'

gem 'valid_url'

gem "honeybadger-api"

gem "google_drive"

skit_gems = ['sessions_instagram', 'sessions_twitter', 'sessions_facebook', 'sessions']

# if ENV["starter_kit_development"].nil?
#   skit_gems.each do |sk|
#     gem "tol_skit_#{sk}", path: "../skit-modules/tol_skit_#{sk}"
#   end
# else
# end

gem 'will_paginate', '~> 3.1.0'

# Gems for development and test tools
group :development, :test do
  # An IRB alternative and runtime developer console
  gem 'pry'

  # A collection of tools used for Rails development
  gem 'tol'

  # When mail is sent from your application, Letter Opener will open a preview in the browser instead of sending.
  gem "letter_opener"

  # RSpec for Rails
  gem "rspec-rails"

  # Capybara is an integration testing tool for rack based web applications. It simulates how a user would interact with a website
  gem "capybara"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Factory Girls creates factories in order to prevent entering unnecessary
  # data when creating models in test mode.
  gem "factory_girl_rails"
end
