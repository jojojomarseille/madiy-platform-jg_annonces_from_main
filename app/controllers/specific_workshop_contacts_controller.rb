class SpecificWorkshopContactsController < BaseController
  def create
    @specific_workshop_contact = SpecificWorkshopContact.new(specific_workshop_contact_params)

    if @specific_workshop_contact.save
      redirect_to page_path("evenements"), notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def specific_workshop_contact_params
    params.require(:specific_workshop_contact).permit(
      :name, :email, :phone_number, :workshop_category, :message, :seats
    )
  end
end
