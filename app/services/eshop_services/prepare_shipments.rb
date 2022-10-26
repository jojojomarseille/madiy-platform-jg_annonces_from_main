module EshopServices
  class PrepareShipments
    def initialize
      @context = OpenStruct.new(success: true, result: nil, errors: [])
    end

    def call(cart:)
      cart.transaction do
        cart.bookings.shipments.group_by(&:creator).each do |creator, to_ship|
          create_shipment!(cart).tap do |shipment|
            to_ship.each do |product|
              shipment.shipment_lines << ShipmentLine.new(shippable: product)
            end
          end
        end
      end

      cart.shipments.each do |shipment|
        Mailers::ShipmentPreparedJob.perform_later(shipment: shipment)
      end
    end

    private

    def create_shipment!(cart)
      address = cart.shipping? ? cart.user.address.dup : nil
      Shipment.create!(cart: cart, address: address, click_and_collect: cart.click_and_collect?)
    end
  end
end
