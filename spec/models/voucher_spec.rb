require "rails_helper"

RSpec.describe Voucher, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:amount_cents) }
    it { is_expected.to validate_presence_of(:from) }
    it { is_expected.to validate_presence_of(:to) }
    it { is_expected.to validate_numericality_of(:amount_cents).is_greater_than(0) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:workshop).optional }
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to have_one(:coupon).dependent(:destroy) }
    it { is_expected.to accept_nested_attributes_for(:coupon) }

    it { is_expected.to have_many(:discounts) }
    it { is_expected.to have_many(:carts).through(:discounts) }
  end

  describe "#activate!" do
    let!(:voucher) { create(:voucher, :with_coupon) }

    it "activates the coupon" do
      expect { voucher.activate! }.to change { voucher.coupon.active }.from(false).to(true)
    end
  end

  describe "#deactivate!" do
    let!(:voucher) { create(:voucher, :with_coupon, active_coupon: true) }

    it "deactivates the coupon" do
      expect { voucher.deactivate! }.to change { voucher.coupon.active }.from(true).to(false)
    end
  end
end
