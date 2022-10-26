class WorkshopsController < BaseController
  def index
    @q = Workshop.ransack(params[:q])
    @workshops = @q.result(distinct: true).visible.includes(:workshop_prices).ordered_by_events.page(params[:page])
    @zones = Zone.joins(:workshops).merge(Workshop.visible)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def index_creator
    @workshops = Workshop.where(creator_id: current_creator.id).where.not(statut: 'supprimé').order(created_at: :DESC )
  end

  def workshop_creator_view
    @creator = current_creator
    @workshop = Workshop.find_by_id(params[:id])
    @workshop_events = @workshop.workshop_events.where(canceled: [nil, false])
    @events_id_array = @workshop.events_id_array
  end

  def destroy_event
    @workshop_event = WorkshopEvent.find(params[:id])
    @workshop = Workshop.where(id: @workshop_event.workshop_id).last
    @workshop_event.canceled = true
    @workshop_event.seats_left = 0
    @workshop_event.save(validate: false)
    redirect_to "/workshops/index_creator/workshop_creator_view/#{@workshop.id}"
  end

  def show
    @workshop = Workshop.visible.find(params[:id])
    @reminder = @workshop.workshop_event_reminders.build
  end

  def updatedelete
    @workshop = Workshop.find(params[:id])
    @workshop.statut = "supprimé"
    @workshop.workshop_events.each do |event|
      event.canceled = true
    end
    @workshop.save(validate: false)
    redirect_to "/workshops/index_creator/'#{current_creator.id}'"
  end

  def publish
    @workshop = Workshop.find(params[:id])
    @workshop.update(statut: "Soumis")
    redirect_to "/workshops/index_creator/'#{current_creator.id}'"
  end

  def new
    @workshop = Workshop.new
    @workshop.build_workshop_duration
    @workshop.workshop_prices.build
    @workshop.build_address
    @categories = WorkshopCategory.all
    @creator = current_creator
  end


  def create
    @workshop = Workshop.new
    @creator = current_creator
    @categories = WorkshopCategory.all
    if params[:commit] == 'Enregistrer en tant que brouillon'
      @workshop = Workshop.new(workshop_params)
      @workshop.statut = "Brouillon"
      @workshop.audience.presence || @workshop.audience = "adult"
      @workshop.category_id.presence || @workshop.category_id = WorkshopCategory.last.id
      @workshop.seats.presence || @workshop.seats = 0
      @workshop.workshop_duration_presence? || @workshop.build_workshop_duration(hours: 0, minutes: 0)
      if @workshop.save(validate: false)
        # redirect_to "/workshops/index_creator/'#{@creator.id}'"
        respond_to do |format|
          format.html {flash[:notice] = "Le brouillon a été créé avec succès" and redirect_to "/workshops/index_creator/'#{@creator.id}'"}
        end
      else
        redirect_to "/workshops/index_creator/'#{@creator.id}'"
      end
      @workshop = Workshop.new(workshop_params)
    else 
      @categories = WorkshopCategory.all
      @workshop = Workshop.new(workshop_params)
        if @workshop.save
          respond_to do |format|
            format.html {flash[:notice] = "L'atelier a été créé" and redirect_to "/workshops/index_creator/'#{current_creator.id}'"}
          end
        else
          render 'new'
        end
    
        # @creator = current_creator
        # context = WorkshopsServices::ProposeWorkshop.call(workshop_params: workshop_params)
        # if context.success
        #   #  head :ok
        #   redirect_to "/workshops/index_creator/'#{current_creator.id}'"
        # else
        #   head :unprocessable_entity
        #   # render 'new'
        # end
    end
  end

  def edit_draft
    @creator = current_creator
    @workshop = Workshop.find(params[:id])
    @categories = WorkshopCategory.all
  end

  # Cette methode est principalement destinée a l'update d'un atelier brouillon et l'ajout de dates a un atelier. voir methode update_seats pour updater le nombre de seats d'un ateleir soumis ou validé. 
  def update
    @creator = current_creator
    @categories = WorkshopCategory.all
    if params[:commit] == 'Soumettre mon brouillon'
      @workshop = Workshop.find(params[:id])
      @workshop.update(workshop_params) 
      @workshop.statut = "Soumis"
        if @workshop.save
          redirect_to "/workshops/index_creator/'#{@creator.id}'"
        else
          render 'new'
        end

    elsif params[:commit] == 'Mettre à jour mon brouillon'
      @workshop = Workshop.find(params[:id])
      @workshop.update(workshop_params)
      @workshop.audience.presence || @workshop.audience = "adult"
      @workshop.category_id.presence || @workshop.category_id = WorkshopCategory.last.id
      @workshop.seats.presence || @workshop.seats = 0
      if @workshop.workshop_duration.presence 
      else
        @workshop_duration = @workshop.build_workshop_duration  
        @workshop_duration.hours = 0
        @workshop_duration.minutes = 0
      end
        @workshop.workshop_events.each do |event|
          event.seats_left = @workshop.seats
        end
      if @workshop.save(validate: false)
        redirect_to "/workshops/index_creator/'#{@creator.id}'"
      else
        redirect_to "/workshops/index_creator/'#{@creator.id}'"
      end
    elsif params[:commit] == 'Reconduire'
      @workshop = Workshop.find(params[:id])
      @workshop.update(workshop_params)
      if @workshop.save
        redirect_to "/workshops/index_creator/workshop_creator_view/#{@workshop.id}"
      else
        # redirect_to "/workshops/index_creator/'#{@creator.id}'"
        render 'new'
      end
    else
      @workshop = Workshop.find(params[:id])
      @workshop.update(workshop_params)
      @workshop.statut = "Soumis"
      if @workshop.save
        redirect_to "/workshops/index_creator/workshop_creator_view/#{@workshop.id}"
      else
        # redirect_to "/workshops/index_creator/'#{@creator.id}'"
        render 'new'
      end
    end
  end

  def update_event_seats
    @event= WorkshopEvent.find(params[:id])
    @event.seats_left = params[:workshop_event][:seats_left]
    @workshop = Workshop.where(id: @event.workshop_id).last
    if @event.save
      redirect_to "/workshops/index_creator/workshop_creator_view/#{@workshop.id}"
    else
      redirect_to "/workshops/index_creator/workshop_creator_view/#{@workshop.id}"
    end
  end
  
  private

  def workshop_params
    params.require(:workshop).permit(
      :title, :goal, :description, :more, :commit, :audience, :seats, :main_picture, {pictures: []}, :statut, :category_id, :creator_id, :zone_id, :visible, :giftable, :online,  :crop_x, :crop_y, :crop_width, :crop_height,
      workshop_duration_attributes: %i[id hours minutes],
      address_attributes: %i[id street postal_code city],
      workshop_events_attributes: %i[id start_time end_time seats_left _destroy],
      workshop_prices_attributes: [:id, :category, :price, :_destroy],
    )
  end
end
