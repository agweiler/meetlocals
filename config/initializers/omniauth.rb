Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']
  # provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET']
  provider :twitter, '2QI1YBn7H5teEMHMHanhW9eWs', 'ZRwdHEUkRxF5y2VdwnXSvul3doiVNXQfAKioD9ppiFIxb6NF1j'
end
