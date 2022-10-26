require "rails_helper"

RSpec.describe SpecificWorkshopContact, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_presence_of(:workshop_category) }
    it { is_expected.to validate_presence_of(:seats) }
    it { is_expected.to validate_presence_of(:message) }
  end
end
