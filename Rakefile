# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

if Rails.env.development? || Rails.env.test?
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new(:rubocop) do |t|
    t.options = ['--display-cop-names']
  end

  task :licensed do
    sh 'bundle exec licensed cache'
    sh 'bundle exec licensed status'
  end

  task :brakeman do
    sh 'bundle exec brakeman'
  end

  Rake::Task[:default].enhance %i[brakeman licensed rubocop spec]
end
