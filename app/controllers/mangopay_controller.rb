class MangopayController < ApplicationController
  PAYIN_NORMAL_FAILED = "PAYIN_NORMAL_FAILED"
  PAYIN_NORMAL_SUCCEEDED = "PAYIN_NORMAL_SUCCEEDED"

  def update
    if permitted_params[:RessourceId].present? && Cart.find_by(transaction_id: permitted_params[:RessourceId])
      case permitted_params[:EventType]
      when PAYIN_NORMAL_SUCCEEDED
        cart = Cart.find_by(transaction_id: permitted_params[:RessourceId])
        cart.transaction do
          cart.paid!
          cart.update! paid_at: Time.current
          cart.set_reference!

          if cart.discount.present? && !cart.discount.voucher.campaign?
            if cart.discount.voucher.workshop.present?
              cart.discount.voucher.deactivate!
              cart.discount.voucher.update!(amount_cents: 0)
            else
              new_amount_cents = cart.discount.voucher.amount_cents - cart.cart_items_amount_cents

              if new_amount_cents <= 0
                cart.discount.voucher.deactivate!
                cart.discount.voucher.update!(amount_cents: 0)
              else
                cart.discount.voucher.update!(amount_cents: new_amount_cents)
              end
            end
          end

          cart.bookings.each do |booking|
            Mailers::WorkshopBookingReminderJob.
              set(wait_until: (booking.workshop_event.start_time - 2.days)).
              perform_later(booking: booking, user: booking.user)

            Mailers::WorkshopBookedJob.perform_later(booking: booking, cart: cart)
          end

          cart.vouchers.each do |voucher|
            voucher.activate!
            Mailers::VoucherJob.perform_later(voucher: voucher, cart: cart)
            Mailers::WorkshopVoucherOrderedJob.perform_later(voucher: voucher, cart: cart) if voucher.workshop.present?
          end

          Mailers::OrderValidatedJob.perform_later(cart: cart)

          EshopServices::PrepareShipments.new.call(cart: cart)
        end
      when PAYIN_NORMAL_FAILED
        cart = Cart.find_by(transaction_id: permitted_params[:RessourceId])
        cart.transaction do
          cart.failed!
          cart.bookings.each(&:deactivate!)
        end
      end
    else
      Sentry.capture_message(
        "[MANGOPAY_WEBHOOK_ERROR] Could not find Cart",
        extra: {
          transaction_id: permitted_params[:RessourceId],
          state: permitted_params[:EventType],
          date: permitted_params[:Date]
        }
      )
    end

    head :ok
  end

  def permitted_params
    params.permit(:RessourceId, :EventType, :Date)
  end
end
