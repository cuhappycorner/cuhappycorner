require 'raven'

Raven.configure do |config|
  config.dsn = 'https://5803a61671ba4619824cd55db1a97ec5:fdb7449ac5ec453dae92e1c212940c3f@sentry.io/103024'
  config.environments = ['staging', 'production']
end