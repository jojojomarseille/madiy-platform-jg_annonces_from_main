module VouchersServices
  class ApplyToCart
    class VoucherNotFound < StandardError; end
    class CartAlreadyHasDiscount < StandardError; end
    class CartIsEmpty < StandardError; end
    class WrongWorkshop < StandardError; end
    class ExpiredVoucher < StandardError; end
    class AlreadyUsedVoucher < StandardError; end
    class MinimumAmountNotMet < StandardError; end
    class BadUser < StandardError; end
    class GiftcardPresence < StandardError; end

    def initialize(voucher_model: Voucher)
      @voucher_model = voucher_model
      @context = OpenStruct.new(success: true, result: nil, errors: [])
    end

    def call(cart:, token:)
      raise(CartAlreadyHasDiscount, "un code promo est déjà appliqué au panier") if cart.discount.present?
      raise(CartIsEmpty, "impossible d'appliquer un code promo sur un panier vide") if cart.cart_items.empty?

      voucher = find_voucher(token)
      
      check_voucher_validity!(voucher, cart)
      apply_voucher(voucher, cart)

      context
    rescue VoucherNotFound, CartAlreadyHasDiscount, CartIsEmpty, WrongWorkshop, ExpiredVoucher, AlreadyUsedVoucher, GiftcardPresence, MinimumAmountNotMet, BadUser => e
      context.success = false
      context.errors << e.message

      context
    end

    private

    attr_reader :voucher_model, :context

    def find_voucher(token)
      voucher_model.find_by_coupon_token(token: token)
    rescue ActiveRecord::RecordNotFound
      raise(VoucherNotFound, "le code promo n'existe pas")
    end

    def check_voucher_validity!(voucher, cart)
      check_expiration_date!(voucher)
      check_max_uses!(voucher)
      check_max_uses_by_user!(voucher, cart)
      check_user!(voucher, cart)
      check_minimum_amount!(voucher, cart)
      check_gift_presence!(voucher, cart)
    end

    def check_expiration_date!(voucher)
      return true if voucher.valid_until.nil?

      raise(ExpiredVoucher, "le code promo n'est plus valable") if voucher.valid_until.past?
    end

    def check_gift_presence!(voucher, cart)
      return true if voucher.notgiftcards.nil? || voucher.notgiftcards == false 

      raise(GiftcardPresence, "le code promo n'est pas utilisable sur les cartes cadeaux") if cart.contain_just_gift?
    end

    def check_max_uses!(voucher)
      return true if voucher.max_uses.nil?

      previous_uses_count = Cart.paid.with_voucher(voucher).count

      raise(AlreadyUsedVoucher, "le code promo n'est plus valable") if previous_uses_count >= voucher.max_uses
    end

    def check_max_uses_by_user!(voucher, cart)
      return if voucher.max_uses_by_user.nil?

      previous_uses_count_for_user = Cart.paid.for_user(cart.user).with_voucher(voucher).count

      raise(AlreadyUsedVoucher, "le code promo n'est plus valable") if previous_uses_count_for_user >= voucher.max_uses_by_user
    end

    def check_user!(voucher, cart)
      return true if voucher.user.nil?

      raise(BadUser, "le code promo n'est pas valable") if cart.user != voucher.user
    end

    def check_minimum_amount!(voucher, cart)
      return true if voucher.minimum_amount_cents.nil?

      raise(MinimumAmountNotMet, "le code promo ne s'applique pas pour moins de #{voucher.amount}€") if voucher.minimum_amount_cents > cart.amount_cents
    end

    def apply_voucher(voucher, cart)
      check_workshop(cart, voucher.workshop) if voucher.workshop.present?

      if voucher.notgiftcards == true && voucher.monoproduct == false
        amount_cents = if voucher.percentage?
          cart.amount_cents_without_gift * (voucher.amount.to_f / 100)
        else
          voucher.amount_cents <= cart.amount_cents_without_gift ? voucher.amount_cents : cart.amount_cents_without_gift
        end

      elsif voucher.notgiftcards == false && voucher.monoproduct == true
        amount_cents = if voucher.percentage?
          cart.amount_cents_monoproduct * (voucher.amount.to_f / 100)
            else
              voucher.amount_cents <= cart.amount_cents_monoproduct ? voucher.amount_cents : cart.amount_cents_monoproduct
            end

      elsif voucher.notgiftcards == true && voucher.monoproduct == true
        amount_cents = if voucher.percentage?
          cart.amount_cents_monoproduct_and_without_gift * (voucher.amount.to_f / 100)
            else
              voucher.amount_cents <= cart.amount_cents_monoproduct_and_without_gift ? voucher.amount_cents : cart.amount_cents_monoproduct_and_without_gift
            end

      elsif voucher.notgiftcards == false && voucher.monoproduct == false
        amount_cents = if voucher.percentage?
           cart.amount_cents * (voucher.amount.to_f / 100)
           else
             voucher.amount_cents
           end

      else
        amount_cents = if voucher.percentage?
          cart.amount_cents * (voucher.amount.to_f / 100)
          else
            voucher.amount_cents
          end
        end

      cart.transaction do
        cart.build_discount(voucher: voucher, amount_cents: amount_cents)
        cart.save!
        context.result = cart.discount
      end
    end

    def check_workshop(cart, workshop)
      workshop_events = WorkshopEvent.where(id: cart.bookings.pluck(:workshop_event_id))
      workshops_ids = workshop_events.pluck(:workshop_id)

      raise(WrongWorkshop, "le code promo n'est utilisable pour aucun atelier présent dans le panier") unless workshops_ids.include?(workshop.id)
    end
  end
end
