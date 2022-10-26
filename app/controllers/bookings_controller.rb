class BookingsController < BaseController
  before_action :authenticate_user!, only: %i[show]

  def show
    @booking = current_user.bookings.find(params[:id])

    respond_to do |format|
      format.pdf { render pdf: "billet-#{@booking.workshop_event.workshop.title.parameterize}", disable_smart_shrinking: true, margin: { top: 0, bottom: 0, left: 0, right: 0 } }
    end
  end

  def create
    event = WorkshopEvent.find(permitted_attributes[:event_id])
    
    # result = BookingsServices::Book.new.call(cart: @cart, event: event, prices: prices_asked, email: current_user.email, first_name: current_user.first_name, last_name: current_user.last_name)
    result = BookingsServices::Book.new.call(cart: @cart, event: event, prices: prices_asked)
    if result.success
      redirect_to carts_path, notice: t(".success")
    else
      redirect_to workshop_path(event.workshop), alert: result.errors.to_sentence
    end
  end

  private

  def permitted_attributes
    params.require(:booking).permit(:event_id, :first_name, :last_name, :email, prices: [:id, :amount])
  end

  def prices_asked
    permitted_attributes[:prices].reduce({}) { |acc, price|
      next acc unless price[:amount].to_i > 0

      price_object = WorkshopPrice.find(price[:id])
      acc.merge(price_object => price[:amount].to_i)
    }
  end
end
