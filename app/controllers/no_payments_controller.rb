class NoPaymentsController < BaseController
  def create
    @cart.transaction do
      @cart.bookings.each(&:activate!)
      @cart.vouchers.each(&:activate!)
      @cart.paid!
      @cart.set_reference!
      @cart.update!(user: current_user, paid_at: Time.current)

      if @cart.discount.present?
        if @cart.discount.voucher.workshop.present?
          @cart.discount.voucher.deactivate!
          @cart.discount.voucher.update!(amount_cents: 0)
        else
          new_amount_cents = @cart.discount.voucher.amount_cents - @cart.cart_items_amount_cents

          if new_amount_cents <= 0
            @cart.discount.voucher.deactivate!
            @cart.discount.voucher.update!(amount_cents: 0)
          else
            @cart.discount.voucher.update!(amount_cents: new_amount_cents)
          end
        end
      end
    end

    @cart.bookings.each do |booking|
      Mailers::WorkshopBookingReminderJob.
        set(wait_until: (booking.workshop_event.start_time - 2.days)).
        perform_later(booking: booking, user: booking.user)

      Mailers::WorkshopBookedJob.perform_later(booking: booking, cart: @cart)
    end

    @cart.vouchers.each do |voucher|
      Mailers::VoucherJob.perform_later(voucher: voucher, cart: @cart)
      Mailers::WorkshopVoucherOrderedJob.perform_later(voucher: voucher, cart: @cart) if voucher.workshop.present?
    end

    Mailers::OrderValidatedJob.perform_later(cart: @cart)
    EshopServices::PrepareShipments.new.call(cart: @cart)

    clear_cart

    redirect_to users_orders_path, notice: t(".success")
  end
end
