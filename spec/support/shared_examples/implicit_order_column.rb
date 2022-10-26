RSpec.shared_examples_for "an implicitly ordered model" do
  it { is_expected.to have_implicit_order_column(:created_at) }
end
