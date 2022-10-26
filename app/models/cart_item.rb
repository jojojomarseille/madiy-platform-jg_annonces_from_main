class CartItem < ApplicationRecord
  belongs_to :cartable, polymorphic: true, dependent: :destroy
  belongs_to :cart

  def amount_cents
    cartable.amount_cents * quantity
  end
end
