# quadio-internal

- Ruby 2.7.1
- Rails 6.1
- PostgreSQL

project setup instructions

# project setup steps

  bundle install (You will need to install bundler first using `gem install bundler:2.2.20`)
  postgreSQL setup
  rails db:create
  rails db:migrate
  rails db:seed
  bundle exec rake webpacker:install

# running sidekiq on local

  bundle exec sidekiq -q high -q default -q mailers -q notifications

# ENV variables
Please review the `.env.example` for required ENV variables during the development.
Please contact developer or get ENV variables from Heroku.

# Mailer
We are using LetterOpener on the development, Maitrap on quadio-development and Gmail SMTP on quadio-staging instance.


