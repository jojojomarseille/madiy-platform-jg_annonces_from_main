FactoryBot.define do
  factory :shipment do
    association :cart, factory: :cart, strategy: :build
    shipped { false }
    token { nil }
  end
end
