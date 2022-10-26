Gibbon::Request.api_key = Rails.application.credentials.mailchimp[:api_key]
Gibbon::Request.timeout = 30
Gibbon::Request.open_timeout = 30
