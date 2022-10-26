
module BookingsServices
  class Book
    class NoPriceSelected < StandardError; end

    def initialize(booking_model: Booking)
      @booking_model = booking_model
      @context = OpenStruct.new(success: true, result: nil, errors: [])
    end

    def call(cart:, event:, prices:)
      raise(NoPriceSelected, "Vous devez au moins sélectionner une place à réserver") if prices.empty?

      cart.transaction do
        prices.map do |(price, amount)|
          booking = booking_model.create!(workshop_event: event, price_category: price.category, seats: price.seats * amount, price_cents: price.price_cents)

          cart.discount.destroy if cart.discount.present?
          CartItem.create!(cart: cart, cartable: booking, quantity: amount)
        end
      end

      context
    rescue => e
      context.success = false
      context.errors << e.message

      context
    end

    private

    attr_reader :booking_model, :context
  end
end