class CartItemsController < BaseController
  before_action :set_cart_item

  def update
    @cart_item.update(cart_item_params)
  end

  def destroy
    @cart_item.destroy
    @cart.discount.destroy if @cart.discount.present?
    @cart.reload
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end

  def set_cart_item
    @cart_item = @cart.cart_items.find(params[:id])
  end
end
