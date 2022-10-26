FactoryBot.define do
  factory :cart do
    trait :with_vouchers do
      transient do
        voucher_count { 3 }
        voucher_amount_cents { rand(1..100) }
      end

      after(:create) do |cart, evaluator|
        evaluator.voucher_count.times do
          voucher = create(:voucher, :with_coupon, amount_cents: evaluator.voucher_amount_cents)
          cart.vouchers << voucher
        end
      end
    end
  end
end
