class CreatorsController < BaseController

  def edit
    @creator_doc = CreatorDoc.new
    @creator = Creator.find(params[:id])
  end
  
  def update
    @creator = Creator.find(params[:id])
    @creator.update(creator_params)
    redirect_to "/creators/edit/#{params[:id]}"
  end

  def create_doc
    @creator_doc = CreatorDoc.new(creator_docs_params)
    if @creator_doc.save
      redirect_to page_path("proposer-atelier"), notice: t(".success")
    else
      redirect_to "/"
    end 
  end
    
  private

  def creator_params
    params.require(:creator).permit(
      :id, :last_name, :first_name, :email, :phone_number, :company, :facebook, :instagram, :tva, :tva_num, :siret, :picture, :click_and_collect, :bio, :legal_statut, :approved, creator_docs_attributes: [:creator_id, :document_type, :statut, :document]
    )
  end
end
