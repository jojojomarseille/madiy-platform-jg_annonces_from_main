require "rails_helper"

RSpec.describe Coupon, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:couponable).with_message(:required) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:couponable) }
  end

  describe "callbacks" do
    describe "on create" do
      describe "token generation" do
        let(:couponable) { create(:voucher) }
        let(:expected_token) { "7aa2976d8f" }

        before { allow(SecureRandom).to receive(:hex).and_return(expected_token) }

        it "sets a token at creation time" do
          coupon = described_class.new(couponable: couponable)

          expect { coupon.save! }.to change { coupon.token }.from(nil).to(expected_token)
        end
      end
    end
  end
end
