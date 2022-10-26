module Users
  class OrdersController < BaseController
    before_action :authenticate_user!

    def index
      @orders = current_user.cart_items.order("paid_at DESC, updated_at DESC")
    end
  end
end
