require 'sidekiq/web'
require 'sidekiq-scheduler/web'
require 'sidekiq'

redis_url = { url: "redis://localhost:6379/0" }

Sidekiq.configure_client do |config|
  config.redis = redis_url
end

run Sidekiq::Web
