PayPal::SDK.configure(
  :mode => Rails.env.production? ? 'live' : 'sandbox',
  :client_id => ENV['PAYPAL_CLIENT_ID'],
  :client_secret => ENV['PAYPAL_CLIENT_SECRET'],
  :ssl_options => { }
)
PayPal::SDK.logger = Rails.logger
