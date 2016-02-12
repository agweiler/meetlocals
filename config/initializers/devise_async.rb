# require 'active_model/version'
# require 'devise/hooks/activatable'
# require 'devise/hooks/csrf_cleaner'

Devise::Models::Authenticatable.module_eval do
  def send_devise_notification(notification, *args)
    message = devise_mailer.send(notification, self, *args)
    # Remove once we move to Rails 4.2+ only.
    if message.respond_to?(:deliver_now)
      message.deliver_later
    else
      message.deliver
    end
  end
end
    