require "rails_helper"

RSpec.describe Cart, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:cart_items).dependent(:destroy) }
    it { is_expected.to have_many(:vouchers).through(:cart_items) }
    it { is_expected.to have_one(:discount) }
    it { is_expected.to have_one(:voucher).through(:discount) }
    it { is_expected.to have_many(:shipments) }

    it { is_expected.to belong_to(:user).optional }
  end

  describe "amount_cents" do
    subject { create(:cart, :with_vouchers, voucher_amount_cents: 100).amount_cents }

    it { is_expected.to eq(300) }

    context "with a discount linked" do
      subject { cart.amount_cents }

      let!(:cart) { create(:cart, :with_vouchers, voucher_amount_cents: 100) }
      let!(:voucher) { create(:voucher, :with_coupon, active_coupon: true, amount_cents: voucher_amount) }

      before { cart.create_discount(voucher: voucher, amount_cents: voucher.amount_cents) }

      context "when the voucher amount is less than the cart total" do
        let(:voucher_amount) { 100 }

        it { is_expected.to eq(200) }
      end

      context "when the voucher amount is more than the cart total" do
        let(:voucher_amount) { 400 }

        it { is_expected.to eq(0) }
      end
    end
  end
end
