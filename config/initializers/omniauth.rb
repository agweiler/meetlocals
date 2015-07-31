Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
  										{ :scope => 'email', :display => 'popup' }
  provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET']
  # provider :facebook,
  #   Rails.application.secrets.FACEBOOK_APP_ID,
  #   Rails.application.secrets.FACEBOOK_APP_SECRET
  # provider :twitter,
  #   Rails.application.secrets.TWITTER_CONSUMER_KEY,
  #   Rails.application.secrets.TWITTER_CONSUMER_SECRET
end
