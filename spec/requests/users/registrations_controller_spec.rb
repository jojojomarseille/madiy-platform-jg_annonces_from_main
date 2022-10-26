require "rails_helper"

RSpec.describe Users::RegistrationsController, type: :request do
  describe "POST #create" do
    let(:newsletter_member) { false }

    context "on success" do
      let(:user_params) { attributes_for(:user, email: "anewuser@email.com", newsletter_member: newsletter_member) }

      it "enqueues a Mangopay::RegisterUserJob" do
        expect(Mangopay::RegisterUserJob).to receive(:perform_later)

        post user_registration_url, params: {user: user_params}
      end

      context "when newsletter is checked" do
        let(:newsletter_member) { true }

        it "calls the mailchimp service" do
          expect(Mailchimp::UpsertNewsletterMemberJob).to receive(:perform_later)

          post user_registration_url, params: {user: user_params}
        end
      end

      context "when newsletter is not checked" do
        let(:newsletter_member) { false }

        it "does not call the mailchimp service" do
          expect(Mailchimp::UpsertNewsletterMemberJob).not_to receive(:perform_later)

          post user_registration_url, params: {user: user_params}
        end
      end
    end

    context "on failure" do
      let(:user_params) { attributes_for(:user, email: nil, newsletter_member: newsletter_member) }

      it "does not enqueue a Mangopay::RegisterUserJob" do
        expect(Mangopay::RegisterUserJob).not_to receive(:perform_later)

        post user_registration_url, params: {user: user_params}
      end

      context "when newsletter is checked" do
        let(:newsletter_member) { true }

        it "does not call the mailchimp service" do
          expect(Mailchimp::UpsertNewsletterMemberJob).not_to receive(:perform_later)

          post user_registration_url, params: {user: user_params}
        end
      end

      context "when newsletter is not checked" do
        let(:newsletter_member) { false }

        it "does not call the mailchimp service" do
          expect(Mailchimp::UpsertNewsletterMemberJob).not_to receive(:perform_later)

          post user_registration_url, params: {user: user_params}
        end
      end
    end
  end
end
