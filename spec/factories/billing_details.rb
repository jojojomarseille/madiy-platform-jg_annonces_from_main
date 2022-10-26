FactoryBot.define do
  factory :billing_detail do
    first_name { "John" }
    last_name { "Doe" }
    phone_number { "0605040302" }
    company { nil }
    association :user, factory: :user, strategy: :build
  end
end
