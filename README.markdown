# Dashboards

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

It is a Rails 5.0.0 app with Ruby 2.2.2

## Setup

    1. Create a new Sentry application and set the DNS: File is located in config/initializers/raven.rb
    2. If active admin is used change the email and password to suit your needs.
    3. Do not work directly in the dashboards folder. Create a copy of it and setup bitbucket for the new project.

## Running on your Machine
Get the source:

    $ git clone dashboards

    $ cd dashboards

Setup rvmrc (assuming you are using TextMate):

    $ mate .rvmrc

Paste the following content and save:

    $ rvm use 2.2.2@dashboards --create

Then:

    $ cd ..
    $ cd dashboards

Then install the bundler gem: 
    $ gem install bundler

Set up the other gems:
    $ bundle install


Next step is to set the environment variables:
    Create a new file 'a_env.rb' in 'config/initializers'
    In this file add the following keys:
    
    ENV['SENTRY_DNS'] = ''

    ENV['FACEBOOK_KEY'] = ''
    ENV['FACEBOOK_SECRET'] = ''

    ENV['TWITTER_KEY'] = ''
    ENV['TWITTER_SECRET'] = ''

    ENV['INSTAGRAM_KEY'] = ''
    ENV['INSTAGRAM_SECRET'] = ''

    ENV['CARRIERWAVE_PROVIDER'] = 'AWS'
    ENV['CARRIERWAVE_ACCESS_KEY'] = ''
    ENV['CARRIERWAVE_SECRET_ACCESS'] = ''
    ENV['CARRIERWAVE_REGION'] = 'us-east-1'
    ENV['CARRIERWAVE_FOG_DIRECTORY'] = '-'
    
    This will work just fine for development environment

I am using postgreSQL for the underlying database. You will need to setup your own config/database.yml. A sample file:

    $ development:
    $   adapter:    postgresql
    $   host:       localhost
    $   database:   dashboards_development
    $   timeout:    5000
    $   encoding:   utf8
    $   pool:       5

If you do not have the database, you should create it:
    $ createdb dashboards_development

Run migrations:

    $ rake db:migrate

Start the server:

    $ rails s

Open <http://localhost:3000> in your browser to see the app running. If you have issues getting the app running, [email me](mailto:rares.salcudean@gmail.com).
