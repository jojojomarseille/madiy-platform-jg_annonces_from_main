class CreatorContactsController < BaseController
  def create
    @creator_contact = CreatorContact.new(creator_contact_params)

    if @creator_contact.save
      redirect_to page_path("proposer-atelier"), notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def creator_contact_params
    params.require(:creator_contact).permit(
      :name, :email, :phone_number, :workshop_category, :city, :website, :message
    )
  end
end
