require "rails_helper"

RSpec.describe WorkshopEvent, type: :model do
  context "validations" do
    it { is_expected.to validate_presence_of(:start_time) }
    it { is_expected.to validate_presence_of(:end_time) }
    it { is_expected.to validate_presence_of(:seats_left) }
    it { is_expected.to validate_numericality_of(:seats_left).is_greater_than_or_equal_to(0).with_message("insuffisantes pour valider ces réservations") }

    it { is_expected.to validate_presence_of(:workshop).with_message(:required) }

    context "on time attributes" do
      let(:end_time) { 1.hour.from_now }

      let(:event) { described_class.new(start_time: start_time, end_time: end_time) }

      before { event.valid? }

      subject { event.errors[:start_time].join(" ") }

      context "when start_time is after end_time" do
        let(:start_time) { 2.hours.from_now }

        it { is_expected.to match(/doit être avant/) }
        it { is_expected.not_to match(/doit être après/) }
      end

      context "when start_time is before current time" do
        let(:start_time) { 1.hour.ago }

        it { is_expected.not_to match(/doit être avant/) }
        it { is_expected.to match(/doit être après/) }
      end
    end
  end

  context "associations" do
    it { is_expected.to belong_to(:workshop) }
  end

  describe "#canceled?" do
    let(:start_time) { 1.hour.from_now }
    let(:end_time) { 2.hours.from_now }

    subject { event.canceled? }

    context "when canceled_at is nil" do
      let(:event) { build(:workshop_event, start_time: start_time, end_time: end_time, canceled_at: nil) }

      it { is_expected.to be(false) }
    end

    context "when canceled_at is not nil" do
      let(:event) { build(:workshop_event, start_time: start_time, end_time: end_time, canceled_at: Time.current) }

      it { is_expected.to be(true) }
    end
  end

  describe "#future?" do
    let(:event) { build(:workshop_event, start_time: start_time, end_time: end_time) }

    subject { event.future? }

    context "when there are nil values given" do
      let(:start_time) { nil }
      let(:end_time) { nil }

      it { is_expected.to be(false) }
    end

    context "when start time and end time are in future" do
      let(:start_time) { 1.hour.from_now }
      let(:end_time) { 2.hours.from_now }

      it { is_expected.to be(true) }
    end

    context "when only end time is in future" do
      let(:start_time) { 1.hour.ago }
      let(:end_time) { 1.hour.from_now }

      it { is_expected.to be(false) }
    end
  end

  describe "#end_time" do
    let(:tomorrow) { 1.day.from_now.at_beginning_of_day }
    let(:expected_end_time) { tomorrow + 1.5.hours }

    let(:workshop) { build(:workshop) }
    let(:duration) { build(:workshop_duration, hours: 1, minutes: 30, workshop: workshop) }

    let(:event) { described_class.new(start_time: tomorrow, workshop: workshop) }

    before { workshop.workshop_duration = duration }

    it "is set before validation" do
      expect { event.valid? }.to change { event.end_time }.from(nil).to(expected_end_time)
    end
  end

  describe "#seats_left" do
    let(:expected_seats_left) { 12 }
    let(:workshop) { build(:workshop, seats: expected_seats_left) }
    let(:duration) { build(:workshop_duration, hours: 1, minutes: 30, workshop: workshop) }
    let(:event) { described_class.new(start_time: 1.hour.from_now, workshop: workshop) }

    before { workshop.workshop_duration = duration }

    it "is set before validation" do
      expect { event.valid? }.to change { event.seats_left }.from(0).to(expected_seats_left)
    end
  end
end
