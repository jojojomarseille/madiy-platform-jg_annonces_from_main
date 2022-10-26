class BillingDetailsController < BaseController
  before_action :authenticate_user!
  before_action :set_billing_detail
  before_action :set_shipping_address

  def create
    @billing_detail.assign_attributes(billing_detail_params)
    current_user.address = nil unless requires_shipping_address?

    if @billing_detail.save
      @cart.update(shipping_mode: billing_detail_params[:shipping_mode])
      redirect_to new_payment_path
    else
      set_shipping_address if current_user.address.nil?
      render :new, status: :unprocessable_entity
    end
  end
  alias_method :update, :create

  private

  def billing_detail_params
    requires_shipping_address? ?
      full_billing_details_params :
      only_billing_details_params
  end

  def full_billing_details_params
    params.require(:billing_detail).permit(
      :first_name, :last_name, :company, :phone_number, :terms, :shipping_mode,
      address_attributes: [:id, :street, :postal_code, :city],
      user_attributes: [
        :id,
        address_attributes: [
          [:id, :street, :postal_code, :city],
        ],
      ],
    )
  end

  def only_billing_details_params
    params.require(:billing_detail).permit(
      :first_name, :last_name, :company, :phone_number, :terms, :shipping_mode,
      address_attributes: [:id, :street, :postal_code, :city],
    )
  end

  def set_billing_detail
    @billing_detail ||= current_user.billing_detail ||
      current_user.build_billing_detail(address: Address.new)
  end

  def set_shipping_address
    @shipping_address = current_user.address || current_user.build_address
  end

  def requires_shipping_address?
    @cart.shipments? && params[:billing_detail][:shipping_mode] == "shipping"
  end
end
