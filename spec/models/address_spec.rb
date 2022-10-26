require "rails_helper"

RSpec.describe Address, type: :model do
  context "validations" do
    it { is_expected.to validate_presence_of(:city) }

    it { is_expected.to validate_presence_of(:addressable).with_message(:required) }
  end

  context "associations" do
    it { is_expected.to belong_to(:addressable) }
  end

  describe "#to_s" do
    let(:address) { build(:address, street: street, postal_code: postal_code, city: city) }

    subject { address.to_s }

    context "with no address given" do
      let(:street) { nil }
      let(:postal_code) { nil }
      let(:city) { nil }

      it { is_expected.to eq("") }
    end

    context "with address given" do
      let(:street) { "12 Rue de la mer" }
      let(:postal_code) { "17000" }
      let(:city) { "La Rochelle" }

      it { is_expected.to eq("12 Rue de la mer, 17000 La Rochelle") }
    end
  end
end
