ActiveAdmin.register Booking do
  preserve_default_filters!
  remove_filter :cart
  remove_filter :cart_item

  includes workshop_event: :workshop

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :workshop_event_id, :seats, :price_category, :email, :booked_by_admin, :first_name, :last_name, :phone_number
  #
  # or
  #
  # permit_params do
  #   permitted = [:workshop_event_id, :seats, :active, :price_cents, :price_category]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  actions :index, :show, :new, :create, :edit, :update

  controller do
    def scoped_collection
      end_of_association_chain.where(active: true)
    end

    def create
      ActiveRecord::Base.transaction do
        create! do |format|
          if @booking.persisted?
            price = WorkshopPrice.find_by!(workshop: @booking.workshop, category: @booking.price_category)

            @booking.update!(price_cents: price.price_cents, seats: @booking.seats * price.seats)
            @booking.activate!

            Mailers::WorkshopBookingReminderJob.set(wait_until: (@booking.workshop_event.start_time - 2.days)).perform_later(booking: @booking, user: nil) if @booking.email.present?
            Mailers::WorkshopBookedByAdminJob.perform_later(booking: @booking)

            format.html { redirect_to admin_booking_path(@booking) }
          end
        end
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      @booking.errors.add(:base, e.message)

      render :new
    end

    def update
      ActiveRecord::Base.transaction do
        @booking = Booking.find(params[:id])
        @booking.deactivate!

        update! do |format|
          @booking.activate!

          if @booking.user.present? || @booking.email.present?
            Mailers::WorkshopBookingReminderJob.set(wait_until: (@booking.workshop_event.start_time - 2.days)).perform_later(booking: @booking, user: @booking.user)
          end

          format.html { redirect_to admin_booking_path(@booking) }
        end
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      @booking.errors.add(:base, e.message)

      render :new
    end
  end

  index do
    selectable_column
    id_column
    column :workshop
    column :first_name
    column :last_name
    column :user
    column :workshop_event
    column :seats
    column :active
    column("Montant") { |booking| Money.new(booking.price_cents) }
    column :created_at
    column :updated_at
    column("Tarif") { |booking| I18n.t("activerecord.attributes.workshop_price.categories.#{booking.price_category}") }
    actions
  end

  show do
    attributes_table do
      row(:workshop_event) { booking.workshop_event.workshop }
      row("Date") { l(booking.workshop_event.start_time, format: :event) }
      row :seats
      row :active
      row("Montant") { Money.new(booking.price_cents) }
      row :price_category
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs do
      if f.object.new_record?
        f.input :seats, label: "Nombre de billets"
        f.input :price_category, as: :select, collection: f.object.class.price_categories.keys
        # f.input :user
        f.input :email
        f.input :first_name
        f.input :last_name
        f.input :phone_number
        f.input :booked_by_admin, as: :boolean, input_html: { checked: true }
      end

      f.input :workshop_event
    end

    f.actions
  end
end
