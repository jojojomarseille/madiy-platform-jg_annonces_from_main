class DiscountsController < BaseController
  def create
    result = VouchersServices::ApplyToCart.new.call(cart: @cart, token: discount_params[:token])

    if result.success
      redirect_to carts_path, notice: t(".success")
    else
      @discount_errors = result.errors
      render :create, status: :unprocessable_entity
    end
  end

  private

  def discount_params
    params.require(:discount).permit(:token)
  end
end
