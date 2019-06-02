require 'sidekiq'
require 'sidekiq-scheduler'

redis_url = { url: "redis://localhost:6379/0" }

Sidekiq.configure_server do |config|
  config.redis = redis_url
end

require_relative './workers'
