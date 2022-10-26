FactoryBot.define do
  factory :workshop_price do
    category { "adult" }
    # seats_left { 1 }
    price { 1200 }
    association :workshop, factory: :workshop, strategy: :build
  end
end
