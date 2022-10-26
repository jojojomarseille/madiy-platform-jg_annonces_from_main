require "rails_helper"

RSpec.describe Mailchimp::UpsertNewsletterMember do
  let(:user) { double(email: "email@domain.com", first_name: "John", last_name: "Doe") }

  describe "#call" do
    context "given a successful" do
      before { mock_successful_mailchimp_newsletter_response(body: request_body) }

      context "subscribe request" do
        let(:request_body) { nil }

        it "return a successful response" do
          result = described_class.new.call(user: user)
          expect(result.success).to be(true)
        end
      end

      context "unsubscribe request" do
        let(:request_body) { "{\"email_address\":\"email@domain.com\",\"status\":\"unsubscribed\",\"tags\":[\"test\"],\"merge_fields\":{\"FNAME\":\"John\",\"LNAME\":\"Doe\"}}" }

        it "return a successful response" do
          result = described_class.new.call(user: user, subscribe: false)
          expect(result.success).to be(true)
        end
      end
    end
  end

  context "given a failed" do
    let(:request_body) do
      "{\"email_address\":\"email@domain.com\",\"status\":\"subscribed\",\"tags\":[\"test\"],\"merge_fields\":{\"FNAME\":\"John\",\"LNAME\":\"Doe\"}}"
    end

    before { mock_failed_mailchimp_newsletter_response(body: request_body) }

    context "subscribe request" do
      it "return a failed response" do
        result = described_class.new.call(user: user)
        expect(result.success).to be(false)
      end
    end
  end
end
