MangoPay.configure do |c|
  c.preproduction = !!ENV.fetch("SANDBOX", !Rails.env.production?)
  c.client_id = ENV.fetch("MANGOPAY_CLIENT_ID", Rails.application.credentials.mangopay[:client_id])
  c.client_apiKey = ENV.fetch("MANGOPAY_API_KEY", Rails.application.credentials.mangopay[:api_key])
  # c.log_file = File.join('mypath', 'mangopay.log')
  c.http_timeout = 10000
end
