require "rails_helper"

RSpec.describe BillingDetail, type: :model do
  describe "#validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_presence_of(:user).with_message(:required) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_acceptance_of(:terms) }
  end

  describe "#associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to accept_nested_attributes_for(:user) }

    it { is_expected.to have_one(:address) }
    it { is_expected.to accept_nested_attributes_for(:address) }
  end
end
