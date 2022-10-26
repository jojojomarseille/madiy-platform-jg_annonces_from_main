class WorkshopEventRemindersController < BaseController
  before_action :set_workshop

  def create
    @reminder = @workshop.workshop_event_reminders.build(permitted_attributes)

    if @reminder.save
      Mailers::WorkshopEventReminderSignupJob.perform_later(reminder: @reminder)
      redirect_to workshop_path(@reminder.workshop), notice: t(".success")
    else
      redirect_to workshop_path(@reminder.workshop), alert: @reminder.errors.full_messages.to_sentence
    end
  end

  private

  def set_workshop
    @workshop = Workshop.visible.find(params[:workshop_id])
  end

  def permitted_attributes
    params.require(:workshop_event_reminder).permit(:email)
  end
end
