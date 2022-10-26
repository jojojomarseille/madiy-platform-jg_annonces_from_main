FactoryBot.define do
  factory :booking do
    workshop_event { nil }
    seats { 1 }
    active { false }
    price_cents { 1 }
  end
end
