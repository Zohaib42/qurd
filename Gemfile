source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'
gem 'rails', '6.1'
gem 'pg'

gem 'rack-mini-profiler', require: false
# For memory profiling
# gem 'memory_profiler'
# For call-stack profiling flamegraphs
# gem 'flamegraph'
# gem 'stackprof'

gem 'aws-sdk-s3', require: false
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 4.3.1'
gem 'cancancan'
gem 'coffee-rails', '~> 5.0.0'
gem 'devise'
gem 'foreman'
gem 'honeybadger', '~> 4.0'
gem 'httparty'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'paranoia'
gem 'puma', '~> 3.11'
gem 'rack-attack'
gem 'rack-cors'
gem 'rollbar'
gem 'rswag-api'
gem 'rswag-ui'
gem 'sass-rails', '~> 6.0'
gem 'stackup'
gem 'toastr-rails'
gem 'turbolinks', '~> 5.2.0'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'uglifier', '~> 4.1.20'
gem 'webpacker'
gem 'jwt'
gem 'name_of_person'
gem 'phonelib'
gem 'interactor-rails'
gem 'image_processing'
gem 'kaminari'
gem 'ffaker'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem "cocoon"
gem 'rpush'
gem 'devise_invitable', '~> 1.5', '>= 1.5.5'

# Not Supported for Rails 6
# no public release yet for rails 6. need to install gem from github branch development.
# https://github.com/influitive/apartment/issues/617
gem 'email_validator'
gem 'forgery', '0.6.0'
gem 'paper_trail'
gem 'rotp'
gem 'ruby-hl7'
gem 'simple_hl7'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 4.0.0.beta2'
  gem 'rswag-specs'
end

group :development do
  gem 'awesome_print'
  gem 'brakeman'
  gem 'letter_opener'
  gem 'letter_opener_web', '~> 1.0'
  gem 'licensed', require: false
  gem 'listen', '~> 3.1.5'
  gem 'rename'
  gem 'rubocop', '~> 0.74.0', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'capybara-screenshot'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'rspec'
  gem 'rspec_junit_formatter'
  gem 'rubocop-rspec'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', '0.17.0', require: false
  gem 'timecop'
  # gem 'rubocop-linter-action'
end
