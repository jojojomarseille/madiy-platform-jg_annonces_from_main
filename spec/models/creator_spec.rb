require "rails_helper"

RSpec.describe Creator, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:phone_number) }
  end

  describe "assocations" do
    it { is_expected.to have_many(:workshops) }
  end
end
