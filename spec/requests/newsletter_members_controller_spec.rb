require "rails_helper"

RSpec.describe NewsletterMembersController, type: :request do
  describe "#create" do
    let(:member_params) { Hash[email: "email@domain.com"] }

    context "on success" do
      before { mock_successful_mailchimp_newsletter_response(with_merge: false) }

      it "redirects to root page" do
        post newsletter_members_url, params: {member: member_params}

        expect(response).to redirect_to(root_url)
      end
    end

    context "on failure" do
      before { mock_failed_mailchimp_newsletter_response(with_merge: false) }

      it "returns http unprocessable entity" do
        post newsletter_members_url, params: {format: :js, member: member_params}

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
