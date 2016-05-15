Rails.configuration.stripe = {
  :publishable_key => "pk_test_INrDyxBhgZvQlq5RqlpwihHx",
  :secret_key      => "sk_test_GfmFMjnGQcWZNcmiHqYteL1x"
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

