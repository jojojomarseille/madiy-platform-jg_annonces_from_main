ActiveAdmin.register WorkshopEvent do
  includes :workshop

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :start_time, :workshop_id, :seats_left
  # or
  # permit_params do
  #   permitted = [:start_time, :end_time, :workshop_id, :seats_left]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  after_action only: %i[create] do
    Mailers::WorkshopEventReminderJob.perform_later(workshop_event: @workshop_event) if @workshop_event.persisted?
  end

  show do
    default_main_content

    panel "Participants" do
      table_for workshop_event.bookings do
        column :price_category
        column :seats
        column("Prénom") { |booking| booking.user&.first_name || booking.first_name }
        column("Nom") { |booking| booking.user&.last_name || booking.last_name }
        column("Email") { |booking| booking.user&.email || booking.email }
      end
    end

  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :workshop
      f.input :start_time, as: :date_time_picker, datepicker_options: {step: 15}
      if f.object.persisted?
        f.input :seats_left
      end
    end
    f.actions
  end
end
