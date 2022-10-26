class PaymentsController < BaseController
  before_action :authenticate_user!
  before_action :ensure_user_has_billing_detail!
  before_action :ensure_not_empty_cart!

  ISO_EUR = -"EUR"
  PLATFORM_FEES = 0

  def new
    @cards = MangoPay::User.cards(current_user.mangopay_id).select { |card| card['Active'] == true }
  end

  def create
    wallet = MangoPay::User.wallets(current_user.mangopay_id).first

    @cart.transaction do
      @cart.bookings.each(&:activate!)
    end

    response = MangoPay::PayIn::Card::Direct.create({
      "AuthorId" => current_user.mangopay_id,
      "CreditedWalletId" => wallet["Id"],
      "DebitedFunds" => {
        "Currency" => ISO_EUR,
        "Amount" => @cart.amount_cents
      },
      "Fees" => {
        "Currency" => ISO_EUR,
        "Amount" => PLATFORM_FEES
      },
      "CardId" => payment_params[:card_id],
      "SecureModeReturnURL" => ENV.fetch("MANGOPAY_SECURE_MODE_RETURN_URL", Rails.application.credentials.mangopay[:secure_mode_return_url]),
      "Tag" => @cart.id,
      "IpAddress" => request.remote_ip,
      "BrowserInfo" => {
        "AcceptHeader" => request.headers["HTTP_ACCEPT"],
        "JavaEnabled" => payment_params[:java_enabled],
        "Language" => "FR-FR",
        "ColorDepth" => payment_params[:color_depth],
        "ScreenHeight" => payment_params[:screen_height],
        "ScreenWidth" => payment_params[:screen_width],
        "TimeZoneOffset" => "+#{Time.zone.utc_offset ? (Time.zone.utc_offset / 60) : 0}",
        "UserAgent" => request.headers["HTTP_USER_AGENT"],
        "JavascriptEnabled" => true
        },
    })

    @cart.transaction do
      @cart.pending!
      @cart.update!(transaction_id: response["Id"], user: current_user)
    end

    clear_cart

    if response["SecureModeNeeded"]
      redirect_to response["SecureModeRedirectURL"]
    else
      redirect_to users_orders_path, notice: t(".success")
    end
  rescue => e
    redirect_to new_payment_path, alert: e.message
  end

  private

  def ensure_user_has_billing_detail!
    redirect_to root_url unless current_user.billing_detail.present?
  end

  def ensure_not_empty_cart!
    redirect_to root_url unless @cart.cart_items.any?
  end

  def payment_params
    params.require(:payment).permit(:card_id, :color_depth, :screen_height, :screen_width, :java_enabled)
  end
end
