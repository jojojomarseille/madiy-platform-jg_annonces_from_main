require "rails_helper"

RSpec.describe Booking, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:workshop_event) }
    it { is_expected.to have_one(:workshop).through(:workshop_event) }
    it { is_expected.to have_one(:creator).through(:workshop) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:seats) }
    it { is_expected.to validate_presence_of(:price_cents) }
    it { is_expected.to validate_presence_of(:workshop_event).with_message(:required) }
    it { is_expected.not_to validate_presence_of(:email) }
  end
end
