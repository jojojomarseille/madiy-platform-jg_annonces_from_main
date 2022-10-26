require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:birthday) }
  end

  describe "associations" do
    it { is_expected.to have_one(:billing_detail).dependent(:destroy) }
    it { is_expected.to have_many(:carts) }
    it { is_expected.to have_many(:paid_carts) }
    it { is_expected.to have_many(:vouchers).through(:paid_carts) }

    it { is_expected.to have_one(:address) }
    it { is_expected.to accept_nested_attributes_for(:address) }
  end
end
