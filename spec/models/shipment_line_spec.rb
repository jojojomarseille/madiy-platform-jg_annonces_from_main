require 'rails_helper'

RSpec.describe ShipmentLine, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:shippable).with_message(:required) }
    it { is_expected.to validate_presence_of(:shipment).with_message(:required) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:shipment) }
    it { is_expected.to belong_to(:shippable) }
  end
end
