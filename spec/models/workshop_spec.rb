require "rails_helper"

RSpec.describe Workshop, type: :model do
  it_behaves_like "an implicitly ordered model"

  context "delegations" do
    it { is_expected.to delegate_method(:total).to(:workshop_duration).with_prefix(true).allow_nil }
  end

  context "validations" do
    it "had a title" do
      expect(Workshop.new).not_to be_valid
    end
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:goal) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:audience) }
    it { is_expected.to validate_presence_of(:seats) }
    it { is_expected.to validate_numericality_of(:seats).is_greater_than(0) }

    it { is_expected.to validate_presence_of(:creator).with_message(:required) }
    it { is_expected.to validate_presence_of(:category).with_message(:required) }

    it {
      is_expected.to define_enum_for(:audience)
        .with_values(adult: "adult", child: "child", adult_and_child: "adult_and_child")
        .backed_by_column_of_type(:enum)
        .with_suffix
    }

    it { is_expected.to allow_values(:adult, :child, :adult_and_child).for(:audience) }
  end

  context "associations" do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:creator) }
    it { is_expected.to belong_to(:zone).optional }

    it { is_expected.to have_one(:workshop_duration)}
    it { is_expected.to have_one(:address) }

    it { is_expected.to have_many(:workshop_prices) }
    it { is_expected.to have_many(:workshop_events) }
    it { is_expected.to have_many(:workshop_event_reminders) }
    it { is_expected.to have_many(:vouchers) }

    it { is_expected.to accept_nested_attributes_for(:workshop_duration) }
    it { is_expected.to accept_nested_attributes_for(:address) }
    it { is_expected.to accept_nested_attributes_for(:workshop_prices) }
    it { is_expected.to accept_nested_attributes_for(:workshop_events) }

    it { is_expected.to have_one_attached(:main_picture) }
    it { is_expected.to have_many_attached(:pictures) }
  end
end
