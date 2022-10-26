FactoryBot.define do
  factory :shipment_line do
    association :shipment, factory: :shipment, strategy: :build
  end
end
