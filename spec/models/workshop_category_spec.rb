require "rails_helper"

RSpec.describe WorkshopCategory, type: :model do
  it_behaves_like "an implicitly ordered model"

  context "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:color) }
  end

  context "associations" do
    it { is_expected.to have_many(:workshops) }
  end
end
