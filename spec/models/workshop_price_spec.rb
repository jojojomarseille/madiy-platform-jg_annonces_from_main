require "rails_helper"

RSpec.describe WorkshopPrice, type: :model do
  it_behaves_like "an implicitly ordered model"

  it {
    is_expected.to define_enum_for(:category)
      .with_values(adult: "adult", child: "child", adult_and_child: "adult_and_child", reduced: "reduced")
      .backed_by_column_of_type(:enum)
      .with_suffix
  }

  context "validations" do
    it { is_expected.to validate_presence_of(:price_cents) }
    it { is_expected.to validate_numericality_of(:price_cents).is_greater_than_or_equal_to(0) }

    it { is_expected.to validate_presence_of(:workshop).with_message(:required) }
    it { is_expected.to allow_values(:adult, :child, :adult_and_child, :reduced).for(:category) }
  end

  context "associations" do
    it { is_expected.to belong_to(:workshop) }
  end
end
