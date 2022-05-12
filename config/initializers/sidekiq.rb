require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq-scheduler'

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" },
    size: 1,
    network_timeout: 5,
    ssl_params: {
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" },
    size: 7,
    network_timeout: 5,
    ssl_params: {
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
  }

  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file('config/sidekiq_scheduler.yml')
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["MONITORING_USERNAME"])) & ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["MONITORING_PASSWORD"]))
end
