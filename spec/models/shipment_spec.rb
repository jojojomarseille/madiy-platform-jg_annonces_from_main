require 'rails_helper'

RSpec.describe Shipment, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:cart).with_message(:required) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:cart) }
    it { is_expected.to have_one(:address) }
    it { is_expected.to have_many(:shipment_lines) }
    it { is_expected.to have_many(:bookings).through(:shipment_lines) }
  end
end
