FactoryBot.define do
  factory :creator do
    sequence(:email) { |n| "creator#{n}@example.com" }

    first_name { "Jack" }
    last_name { "O'Lantern" }
    phone_number { "0605040302" }
    password { "Password5!" }
  end
end
