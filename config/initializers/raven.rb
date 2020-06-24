require 'raven'

Raven.configure do |config|
  config.dsn = '${RAVEN_KEY}'
  config.environments = %w(staging production)
end
