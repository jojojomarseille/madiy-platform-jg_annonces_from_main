require "rails_helper"

RSpec.describe WorkshopDuration, type: :model do
  it_behaves_like "an implicitly ordered model"

  context "validations" do
    it { is_expected.to validate_presence_of(:hours) }
    it { is_expected.to validate_presence_of(:minutes) }
  end

  context "associations" do
    it { is_expected.to belong_to(:workshop) }
  end

  describe "#total" do
    context "when no hours or minutes set" do
      subject { described_class.new.total }

      it { is_expected.to be_nil }
    end

    context "when duration is set" do
      subject { described_class.new(hours: 1, minutes: 45).total }

      it { is_expected.to eq(1.hours + 45.minutes) }
    end
  end
end
