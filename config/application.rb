require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Quadio
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.action_controller.default_protect_from_forgery = true

    # Autoload custom directories
    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app', 'services')
    config.autoload_paths << Rails.root.join('app', 'interactors')
    config.autoload_paths << Rails.root.join('app', 'models', 'users')
    config.autoload_paths << Rails.root.join('app', 'queries')
    config.autoload_paths << Rails.root.join('app', 'decorators')
    config.active_job.queue_adapter = :sidekiq
  end
end
