web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -q default -q mailers -q mailer -c 1 -v