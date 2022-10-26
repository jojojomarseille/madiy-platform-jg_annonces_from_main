FactoryBot.define do
  factory :address do
    street { "1 Avenue de Colmar" }
    postal_code { "17000" }
    city { "La Rochelle" }
    association :addressable, factory: :workshop, strategy: :build
  end
end
