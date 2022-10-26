module Mailers
  class WorkshopBookingReminderJob < ApplicationJob
    include Rails.application.routes.url_helpers

    queue_as :default

    def perform(booking:, user:)
      workshop_event = booking.workshop_event
      workshop = workshop_event.workshop

      email = user&.email || booking.email
      first_name = user&.first_name || email

      Mailjet::Send.create(messages: [{
        'From'=> {
          'Email'=> "hello@mesateliersdiy.fr",
          'Name'=> "Mes ateliers DIY"
        },
        'To'=> [
          {
            'Email'=> email,
          }
        ],
        'TemplateID'=> 1875915,
        'TemplateLanguage'=> true,
        'Subject'=> "Rappel de réservation : Votre atelier approche ! ",
        'Variables'=> {
          "first_name" => first_name,
          "workshop_title" => workshop.title,
          "image_url" => url_for(workshop.main_picture),
          "workshop_date" => I18n.l(workshop_event.start_time, format: :event),
          "workshop_duration" => workshop_duration(workshop),
          "workshop_price" => "#{booking.seats} x #{I18n.t("activerecord.attributes.workshop_price.categories.#{booking.price_category}")} #{booking.price.to_s}€",
          "total_price" => "Total : #{Money.new(booking.total_price_cents).to_s}€",
          "workshop_more" => workshop.more,
          "workshop_creator" => "#{workshop.creator.first_name}, #{workshop.creator.company}",
          "workshop_address" => workshop.address.to_s,
        }
      }])
    end

    private

    def default_url_options
      Rails.application.config.x.active_job.default_url_options
    end

    def workshop_duration(workshop)
      duration = workshop.duration
      minutes = duration.minutes > 0 ? ("%02d" % workshop.duration.minutes) : nil

      "#{duration.hours}h#{minutes}"
    end
  end
end
