class CardRegistrationsController < BaseController
  def create
    respond_to do |format|
      format.js do
        @card_registration = MangoPay::CardRegistration.create({"UserId" => current_user.mangopay_id, "Currency" => "EUR", "CardType" => "CB_VISA_MASTERCARD"})
      end
    end
  end
end
