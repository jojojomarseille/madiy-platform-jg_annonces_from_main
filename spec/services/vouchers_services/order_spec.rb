require "rails_helper"

RSpec.describe VouchersServices::Order do
  let!(:cart) { create(:cart) }
  let(:voucher_params) { nil }

  describe ".call" do
    it "delegates to the instance" do
      instance = described_class.new

      allow(described_class).to receive(:new).and_return(instance)
      expect(instance).to receive(:call).with(cart: cart, voucher_params: voucher_params)

      described_class.call(cart: cart, voucher_params: voucher_params)
    end
  end

  describe "#call" do
    let(:service) { described_class.new }

    context "with valid input" do
      let(:voucher_params) { valid_voucher_params }

      it "creates a voucher" do
        expect { service.call(voucher_params: voucher_params, cart: cart) }
          .to change { Voucher.count }
          .by(1)
      end

      it "creates a coupon" do
        expect { service.call(voucher_params: voucher_params, cart: cart) }
          .to change { Coupon.count }
          .by(1)
      end

      it "returns a voucher in the context" do
        result = service.call(voucher_params: voucher_params, cart: cart)
        expect(result.result).to be_a(Voucher)
      end

      it "is successful" do
        result = service.call(voucher_params: voucher_params, cart: cart)
        expect(result.success).to be(true)
      end

      it "adds the voucher to the cart" do
        expect { service.call(voucher_params: voucher_params, cart: cart) }
          .to change { cart.vouchers.size }
          .by(1)
      end
    end

    context "with invalid input" do
      let(:voucher_params) { invalid_voucher_params }

      it "does not create a voucher" do
        expect { service.call(voucher_params: voucher_params, cart: cart) }
          .not_to change { Voucher.count }
      end

      it "does not create a coupon" do
        expect { service.call(voucher_params: voucher_params, cart: cart) }
          .not_to change { Coupon.count }
      end

      it "returns a voucher in the context" do
        result = service.call(voucher_params: voucher_params, cart: cart)
        expect(result.result).to be_a(Voucher)
      end

      it "returns a not persisted voucher in the context" do
        result = service.call(voucher_params: voucher_params, cart: cart)
        expect(result.result).not_to be_persisted
      end

      it "is not succesfull" do
        result = service.call(voucher_params: voucher_params, cart: cart)
        expect(result.success).to be(false)
      end

      it "does not add the voucher to the cart" do
        expect { service.call(voucher_params: voucher_params, cart: cart) }
          .not_to change { cart.vouchers.size }
      end
    end
  end
end
