FactoryBot.define do
  factory :cart_item do
    association :cart, factory: :cart, strategy: :build
    quantity { 1 }
  end
end
