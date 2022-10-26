class Voucher < ApplicationRecord
  belongs_to :workshop, optional: true
  belongs_to :user, optional: true

  has_one :coupon, as: :couponable, dependent: :destroy
  accepts_nested_attributes_for :coupon

  has_many :discounts
  has_many :carts, through: :discounts

  validates :amount_cents, :from, :to, presence: true
  validates :amount_cents, numericality: {greater_than: 0}, on: :create

  monetize :amount_cents
  monetize :minimum_amount_cents, allow_nil: true

  scope :active, -> { joins(:coupon).merge(Coupon.active) }

  def self.find_by_coupon_token(token:)
    active.find_by!(coupons: { token: token.downcase })
  end

  def activate!
    coupon.update!(active: true)
  end

  def deactivate!
    coupon.update!(active: false)
  end

  def coupon_token
    coupon.token.upcase
  end

  def to_s
    return "Carte cadeau pour l'atelier #{workshop.title}" if workshop.present?

    "Carte cadeau d'une valeur de #{amount.to_f}€"
  end
end
