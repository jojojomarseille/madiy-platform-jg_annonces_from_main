require 'rails_helper'

RSpec.describe WorkshopEventReminder, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:workshop).with_message(:required) }
    it { is_expected.to validate_presence_of(:email) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:workshop) }
  end
end
