class BaseController < ApplicationController
  include CurrentCart

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cart

  protected

  def configure_permitted_parameters
    keys = %i[first_name last_name birthday newsletter_member]

    devise_parameter_sanitizer.permit(:sign_up, keys: keys)
    devise_parameter_sanitizer.permit(:account_update, keys: keys)
  end
end
