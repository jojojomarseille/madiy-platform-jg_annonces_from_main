require 'rails_helper'

RSpec.describe Zone, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "associations" do
    it { is_expected.to have_many(:workshops) }
  end
end
