FactoryBot.define do
  factory :voucher do
    amount_cents { 3000 }
    from { "Jane" }
    to { "Joe" }

    trait :with_coupon do
      transient do
        active_coupon { false }
      end

      after(:build) do |voucher, evaluator|
        voucher.build_coupon(active: evaluator.active_coupon)
      end
    end
  end
end
