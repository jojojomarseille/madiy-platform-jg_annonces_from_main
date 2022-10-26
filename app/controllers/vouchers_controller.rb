class VouchersController < BaseController
  before_action :authenticate_user!, only: %i[show]

  def show
    @voucher = current_user.vouchers.find(params[:id])

    respond_to do |format|
      template = @voucher.workshop.present? ? "with_workshop" : "show"
      format.pdf { render pdf: "show", disable_smart_shrinking: true, margin: { top: 0, bottom: 0, left: 0, right: 0 }, template: "vouchers/#{template}" }
    end
  end

  def new
    if params[:workshop_id].present?
      @workshop = Workshop.find_by(id: params[:workshop_id])
    end

    @voucher = Voucher.new
  end

  def create
    service = VouchersServices::Order.call(cart: @cart, voucher_params: voucher_params)

    if service.success
      redirect_to carts_url, notice: t(".success")
    else
      @voucher = service.result
      @workshop = @voucher.workshop
      render :new
    end
  end

  private

  def voucher_params
    params.require(:voucher).permit(
      :from,
      :to,
      :message,
      :email,
      :amount,
      :amount_cents,
      :workshop_id,
    )
  end
end
