class Discount < ApplicationRecord
  belongs_to :voucher
  belongs_to :cart

  validates :amount_cents, presence: true, numericality: {greater_than: 0}
end
