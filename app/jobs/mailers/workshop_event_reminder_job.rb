module Mailers
  class WorkshopEventReminderJob < ApplicationJob
    include Rails.application.routes.url_helpers

    queue_as :default

    def perform(workshop_event:)
      workshop = workshop_event.workshop

      workshop.workshop_event_reminders.each do |reminder|
        user = User.find_by(email: reminder.email)

        Mailjet::Send.create(messages: [{
          'From'=> {
            'Email'=> "hello@mesateliersdiy.fr",
            'Name'=> "Mes ateliers DIY"
          },
          'To'=> [
            {
              'Email'=> reminder.email,
            }
          ],
          'TemplateID'=> 1876052,
          'TemplateLanguage'=> true,
          'Subject'=> "Nouvelles dates disponibles pour l'atelier #{workshop.title}",
          'Variables'=> {
            "first_name" => user ? user.first_name : "",
            "workshop_title" => workshop.title,
            "event_date" => I18n.l(workshop_event.start_time, format: :event),
            "event_address" => workshop.address ? workshop.address.to_s : "",
            "workshop_url" => workshop_url(workshop),
          }
        }])
      end
    end

    private

    def default_url_options
      Rails.application.config.x.active_job.default_url_options
    end
  end
end
