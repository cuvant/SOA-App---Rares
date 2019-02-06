Raven.configure do |config|
  config.dsn = ENV['SENTRY_DNS']
  config.excluded_exceptions = []
  config.environments = %w[ production ]
end
