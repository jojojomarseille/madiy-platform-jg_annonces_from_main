require "rails_helper"

RSpec.describe CartItem, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:cart).with_message(:required) }
    it { is_expected.to validate_presence_of(:cartable).with_message(:required) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:cartable).dependent(:destroy) }
    it { is_expected.to belong_to(:cart) }
  end

  describe "amount_cents" do
    subject { cart_item.amount_cents }
    let!(:voucher) { create(:voucher, amount_cents: 2000) }
    let!(:cart_item) { create(:cart_item, cartable: voucher, quantity: 3) }

    it { is_expected.to eq(6000) }
  end
end
