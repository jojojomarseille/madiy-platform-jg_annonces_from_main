module MailChimpResponsesHelper
  def mock_failed_mailchimp_newsletter_response(body: nil, email: "email@domain.com", with_merge: true)
    response = {
      body: "{\"type\":\"http://developer.mailchimp.com/documentation/mailchimp/guides/error-glossary/\",\"title\":\"Invalid Resource\",\"status\":400,\"detail\":\"test@example.com looks fake or invalid, please enter a real email address.\",\"instance\":\"5116eaac-c475-4268-8b51-dd422706b0e9\"}",
      status: 400
    }

    mock_mailchimp_newsletter_response(body: body, email: email, response: response, with_merge: with_merge)
  end

  def mock_successful_mailchimp_newsletter_response(body: nil, email: "email@domain.com", with_merge: true)
    response = {
      body: "",
      status: 200
    }

    mock_mailchimp_newsletter_response(body: body, email: email, response: response, with_merge: with_merge)
  end

  def mock_mailchimp_newsletter_response(body:, email:, response:, with_merge:)
    email_hash = Digest::MD5.hexdigest(email)

    stub_request(:put, "https://us10.api.mailchimp.com/3.0/lists/test_newsletter_id/members/#{email_hash}")
      .with(
        body: body || default_mailchimp_newsletter_request_body(with_merge: with_merge),
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Basic YXBpa2V5Ojk4Ynp6NWQwOGUwN2QxMDI5NmI3NGYyYTYyMWE0YzJhLXVzMTA=",
          "Content-Type" => "application/json",
          "User-Agent" => "Faraday v1.8.0"
        }
      )
      .to_return(status: response[:status], body: response[:body], headers: {})
  end

  def default_mailchimp_newsletter_request_body(with_merge:)
    with_merge ?
      "{\"email_address\":\"email@domain.com\",\"status\":\"subscribed\",\"tags\":[\"test\"],\"merge_fields\":{\"FNAME\":\"John\",\"LNAME\":\"Doe\"}}" :
      "{\"email_address\":\"email@domain.com\",\"status\":\"subscribed\",\"tags\":[\"test\"]}"
  end
end

RSpec.configure do |c|
  c.include MailChimpResponsesHelper
end
