FactoryBot.define do
  factory :discount do
    amount_cents { 1 }
    voucher { nil }
    cart { nil }
  end
end
