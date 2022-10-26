FactoryBot.define do
  factory :coupon do
    token { SecureRandom.hex(5) }
  end
end
