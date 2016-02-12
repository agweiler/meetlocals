web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -q default -q mailers -q mailer -q paperclip -c 3 -v