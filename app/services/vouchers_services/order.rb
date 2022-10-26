module VouchersServices
  class Order
    def initialize(voucher_model: Voucher)
      @voucher_model = voucher_model
      @context = OpenStruct.new(success: true, result: nil)
    end

    def self.call(**parameters)
      new.call(**parameters)
    end

    def call(cart:, voucher_params:)
      voucher_model.transaction do
        voucher = create_voucher!(voucher_params)
        add_to_cart!(cart, voucher)
      end

      context
    rescue ActiveRecord::RecordInvalid
      context.success = false
      context
    rescue StandardError => e
      context.success = false
      context.result.errors.add(:base, e.message)
      context
    end

    private

    attr_reader :voucher_model, :context

    def create_voucher!(voucher_params)
      voucher_model.new(voucher_params).tap do |voucher|
        context.result = voucher
        ensure_remaining_seats!(voucher)
        voucher.save!
        voucher.create_coupon!
      end
    end

    def add_to_cart!(cart, voucher)
      cart.discount.destroy if cart.discount.present?
      cart.vouchers << voucher
    end

    def ensure_remaining_seats!(voucher)
      return true if voucher.workshop.nil?

      raise(StandardError, "il n'y a plus de places disponibles pour cet atelier") if voucher.workshop.vouchers.count >= voucher.workshop.seats
    end
  end
end
