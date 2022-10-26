class ShipmentLine < ApplicationRecord
  belongs_to :shipment
  belongs_to :shippable, polymorphic: true
end
