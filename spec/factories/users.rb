FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }

    first_name { "John" }
    last_name { "Doe" }
    password { "password" }
    birthday { 20.years.ago }
  end
end
