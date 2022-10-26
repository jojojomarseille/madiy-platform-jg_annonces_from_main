require "rails_helper"

RSpec.describe VouchersServices::ApplyToCart do
  describe "#call" do
    let!(:voucher_workshop) { nil }
    let!(:cart) { create(:cart) }
    let!(:voucher) { create(:voucher, :with_coupon, active_coupon: active_voucher, amount_cents: 100, workshop: voucher_workshop) }
    let(:token) { voucher.coupon_token }

    let(:command_call) { described_class.new.call(cart: cart, token: token) }

    context "when given valid input" do
      shared_examples_for "a successful voucher apply" do
        it "adds a discount to the cart" do
          expect { command_call }.to change { cart.discount }.from(nil).to(Discount)
        end

        it "is successful" do
          result = command_call

          expect(result.success).to be(true)
        end
      end

      context "with a workshop" do
        let!(:voucher_workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: voucher_workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }

        before { cart.bookings << booking }

        it_behaves_like "a successful voucher apply"
      end

      context "without a workshop" do
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }

        before { cart.bookings << booking }

        it_behaves_like "a successful voucher apply"
      end

      context "with monoproduct true" do
        let!(:voucher) { create(:voucher, :with_coupon, active_coupon: active_voucher, amount_cents: 100, monoproduct: true) }
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }

        before { cart.bookings << booking }

        it_behaves_like "a successful voucher apply"
      end

      context "with notgiftcards true" do
        let!(:voucher) { create(:voucher, :with_coupon, active_coupon: active_voucher, amount_cents: 100, notgiftcards: true) }
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }

        before { cart.bookings << booking }

        it_behaves_like "a successful voucher apply"
      end

      context "with notgiftcards and monoproduct true" do
        let!(:voucher) { create(:voucher, :with_coupon, active_coupon: active_voucher, amount_cents: 100, notgiftcards: true, monoproduct: true) }
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }

        before { cart.bookings << booking }

        it_behaves_like "a successful voucher apply"
      end

      context "with notgiftcards and monoproduct nil" do
        let!(:voucher) { create(:voucher, :with_coupon, active_coupon: active_voucher, amount_cents: 100, notgiftcards: nil, monoproduct: nil) }
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }

        before { cart.bookings << booking }

        it_behaves_like "a successful voucher apply"
      end

      context "with notgiftcards and monoproduct false" do
        let!(:voucher) { create(:voucher, :with_coupon, active_coupon: active_voucher, amount_cents: 100, notgiftcards: false, monoproduct: false) }
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }

        before { cart.bookings << booking }

        it_behaves_like "a successful voucher apply"
      end

      context "with a future expiration date" do
        let!(:voucher) { create(:voucher, :with_coupon, active_coupon: active_voucher, amount_cents: 100, workshop: voucher_workshop, valid_until: 2.days.from_now) }
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }

        before { cart.bookings << booking }

        it_behaves_like "a successful voucher apply"
      end

      context "with a max uses" do
        let!(:voucher) { create(:voucher, :with_coupon, campaign: true, active_coupon: active_voucher, amount_cents: 100, workshop: voucher_workshop, max_uses: 2) }
        let!(:other_cart_with_coupon) { create(:cart, voucher: voucher) }
        let!(:discount) { create(:discount, cart: other_cart_with_coupon, voucher: voucher) }

        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }

        before { other_cart_with_coupon.paid!; cart.bookings << booking }

        it_behaves_like "a successful voucher apply"
      end

      context "with a minimum amount" do
        let!(:voucher) { create(:voucher, :with_coupon, campaign: true, active_coupon: active_voucher, amount_cents: 100, workshop: voucher_workshop, minimum_amount_cents: 10) }
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }

        before { cart.bookings << booking }

        it_behaves_like "a successful voucher apply"
      end

      context "with a user linked" do
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }
        let!(:user) { create(:user) }
        let!(:cart) { create(:cart, user: user) }
        let!(:voucher) { create(:voucher, :with_coupon, campaign: true, active_coupon: active_voucher, amount_cents: 100, workshop: voucher_workshop, user: user) }

        before { cart.bookings << booking }

        it_behaves_like "a successful voucher apply"
      end

      context "with a max uses by user" do
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }
        let!(:user) { create(:user) }
        let!(:cart) { create(:cart, user: user) }
        let!(:past_cart) { create(:cart, voucher: voucher, user: user) }
        let!(:discount) { create(:discount, cart: past_cart, voucher: voucher) }
        let!(:voucher) { create(:voucher, :with_coupon, campaign: true, active_coupon: active_voucher, amount_cents: 100, workshop: voucher_workshop, max_uses_by_user: 2) }

        before { past_cart.paid!; cart.bookings << booking }

        it_behaves_like "a successful voucher apply"
      end
    end

    context "when given invalid input" do
      shared_examples_for "a failed voucher apply" do
        it "does not add a discount to the cart" do
          expect { command_call }.not_to change { cart.discount }
        end

        it "is not successful" do
          result = command_call

          expect(result.success).to be(false)
        end
      end

      context "with an inactive voucher" do
        let(:active_voucher) { false }
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }

        before { cart.bookings << booking }

        it_behaves_like "a failed voucher apply"

        it "returns the right error" do
          result = command_call

          expect(result.errors.first).to match(/promo n'existe pas/)
        end
      end
      
      context "with a discount already applied" do
        let(:active_voucher) { true }
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }

        before do
          cart.bookings << booking
          cart.create_discount(voucher: voucher)
        end

        it_behaves_like "a failed voucher apply"

        it "returns the right error" do
          result = command_call

          expect(result.errors.first).to match(/déjà appliqué au panier/)
        end
      end

      context "with the wrong workshop" do
        let(:active_voucher) { true }
        let!(:voucher_workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }

        before { cart.bookings << booking }

        it_behaves_like "a failed voucher apply"

        it "returns the right error" do
          result = command_call

          expect(result.errors.first).to match(/pour aucun atelier présent/)
        end
      end

      context "with an empty cart" do
        let(:active_voucher) { true }

        it_behaves_like "a failed voucher apply"

        it "returns the right error" do
          result = command_call

          expect(result.errors.first).to match(/un panier vide/)
        end
      end

      context "with a past expiration date" do
        let!(:voucher) { create(:voucher, :with_coupon, active_coupon: active_voucher, amount_cents: 100, workshop: voucher_workshop, valid_until: 2.days.ago) }
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }

        before { cart.bookings << booking }

        it_behaves_like "a failed voucher apply"
      end

      context "with a max uses" do
        let!(:voucher) { create(:voucher, :with_coupon, campaign: true, active_coupon: active_voucher, amount_cents: 100, workshop: voucher_workshop, max_uses: 1) }
        let!(:other_cart_with_coupon) { create(:cart, voucher: voucher) }
        let!(:discount) { create(:discount, cart: other_cart_with_coupon, voucher: voucher) }

        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }

        before { other_cart_with_coupon.paid!; cart.bookings << booking }

        it_behaves_like "a failed voucher apply"
      end

      context "with a minimum amount" do
        let!(:voucher) { create(:voucher, :with_coupon, campaign: true, active_coupon: active_voucher, amount_cents: 100, workshop: voucher_workshop, minimum_amount_cents: 200) }
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }

        before { cart.bookings << booking }

        it_behaves_like "a failed voucher apply"
      end

      context "with another user linked" do
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }
        let!(:other_user) { create(:user) }
        let!(:cart) { create(:cart, user: create(:user)) }
        let!(:voucher) { create(:voucher, :with_coupon, campaign: true, active_coupon: active_voucher, amount_cents: 100, workshop: voucher_workshop, user: other_user) }

        before { cart.bookings << booking }

        it_behaves_like "a failed voucher apply"
      end

      context "with a max uses by user" do
        let!(:workshop) { create(:workshop, :complete, creator: create(:creator)) }
        let!(:workshop_event) { create(:workshop_event, workshop: workshop) }
        let!(:booking) { create(:booking, workshop_event: workshop_event, seats: 1, price_cents: 100) }
        let(:active_voucher) { true }
        let!(:user) { create(:user) }
        let!(:cart) { create(:cart, user: user) }
        let!(:past_cart) { create(:cart, voucher: voucher, user: user) }
        let!(:discount) { create(:discount, cart: past_cart, voucher: voucher) }
        let!(:voucher) { create(:voucher, :with_coupon, campaign: true, active_coupon: active_voucher, amount_cents: 100, workshop: voucher_workshop, max_uses_by_user: 1) }

        before { past_cart.paid!; cart.bookings << booking }

        it_behaves_like "a failed voucher apply"
      end
    end
  end
end