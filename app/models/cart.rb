class Cart < ApplicationRecord
  enum state: {
    picking: "picking",
    pending: "pending",
    paid: "paid",
    failed: "failed"
  }

  enum shipping_mode: {
    no_shipping: "no_shipping",
    shipping: "shipping",
    click_and_collect: "click_and_collect"
  }

  has_many :cart_items, dependent: :destroy
  has_many :vouchers, through: :cart_items, source: :cartable, source_type: "Voucher"
  has_many :bookings, through: :cart_items, source: :cartable, source_type: "Booking"

  has_many :shipments

  has_one :discount
  has_one :voucher, through: :discount

  belongs_to :user, optional: true

  scope :visible, -> { where(state: %w(pending paid failed)) }
  scope :recent, -> (limit) { order(paid_at: :desc).limit(limit) }

  scope :with_voucher, -> (voucher) {
    joins(:discount).where(discounts: { voucher: voucher })
  }

  scope :for_user, -> (user) { where(user: user) }

  def cart_items_amount_cents
    cart_items.sum(&:amount_cents)
  end

  def amount_cents
    total =  cart_items_amount_cents - discount_amount

    total.negative? ? 0 : total
  end

  def amount_cents_without_gift
    total = cart_items.where(cartable_type: "Booking").sum(&:amount_cents)
    total == nil ? total == 0 : total
    total.negative? ? 0 : total
  end

  def contain_just_gift?
    if self.cart_items.where(cartable_type: "Booking").blank?
      return true
    else
      return false
    end
  end
  
  def amount_cents_monoproduct
    cart_items_amounts = []
    cart_items.each do |cart_item|
      cart_items_amounts << cart_item.amount_cents
    end
    total = cart_items_amounts.sort.first
    total.negative? ? 0 : total
  end

  def amount_cents_monoproduct_and_without_gift
    cart_items_amounts = []
    cart_items.each do |cart_item|
      if cart_item.cartable_type == "Booking"
        cart_items_amounts << cart_item.amount_cents
      else
      end
    end
    total = cart_items_amounts.sort.first
    if total.nil? 
      total = 0 
    else
    end
    total.negative? ? 0 : total
  end

  def public_reference
    return "" unless reference

    "247-#{reference.to_s.rjust(3, "0")}"
  end

  def set_reference!
    max = self.class.maximum(:reference) || 0

    self.update!(reference: max + 1)
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  def shipments?
    bookings.shipments?
  end

  def shipments_with_click_and_collect?
    bookings.shipments_with_click_and_collect?
  end

  def shipments_with_click_and_collect
    bookings.shipments_with_click_and_collect
  end

  private

  def discount_amount
    return 0 unless discount.present?
    discount.amount_cents
  end
end
