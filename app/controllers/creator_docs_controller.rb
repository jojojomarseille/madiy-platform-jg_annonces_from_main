class CreatorDocsController < BaseController

  include Rails.application.routes.url_helpers
  
  def create
    @creator_doc = CreatorDoc.new(creator_docs_params)
    @creator = Creator.where(id: current_creator.id).last 
    if @creator_doc.save
      redirect_to "/creators/edit/#{@creator.id}"
    else
      redirect_to "/creators/edit/#{@creator.id}"
    end 
  end

  def new
  @creator_doc = CreatorDoc.new
  end

  private

  def creator_docs_params 
    params.require(:creator_doc).permit(:id, :creator_id, :document_type, :statut, :document)
  end
end