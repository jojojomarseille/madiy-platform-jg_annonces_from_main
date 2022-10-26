class Shipment < ApplicationRecord
  has_secure_token

  belongs_to :cart
  has_one :address, as: :addressable, dependent: :destroy

  has_many :shipment_lines, dependent: :destroy
  has_many :bookings, through: :shipment_lines, source: :shippable, source_type: "Booking"

  scope :not_shipped, -> { where(shipped: false) }
end
