module VoucherParamsHelper
  def valid_voucher_params
    attributes_for(:voucher)
  end

  def invalid_voucher_params
    attributes_for(:voucher, from: "")
  end
end

RSpec.configure do |c|
  c.include VoucherParamsHelper
end
