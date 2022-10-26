require "rails_helper"

RSpec.describe Mailchimp::UpsertNewsletterMemberJob, type: :job do
  let(:service) { Mailchimp::UpsertNewsletterMember.new }
  let!(:user) { create(:user, newsletter_member: newsletter_member) }

  before { allow(Mailchimp::UpsertNewsletterMember).to receive(:new).and_return(service) }

  context "when the user is member of the newsletter" do
    let(:newsletter_member) { true }
    it "calls the mailchimp service" do
      expect(service).to receive(:call!).with(user: user, subscribe: true)

      described_class.perform_now(user: user)
    end
  end

  context "when the user is not member of the newsletter" do
    let(:newsletter_member) { false }
    it "calls the mailchimp service" do
      expect(service).to receive(:call!).with(user: user, subscribe: false)

      described_class.perform_now(user: user)
    end
  end
end
