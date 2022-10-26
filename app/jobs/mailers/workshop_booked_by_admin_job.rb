module Mailers
  class WorkshopBookedByAdminJob < ApplicationJob
    queue_as :default

    def perform(booking:)
      workshop = booking.workshop
      creator = workshop.creator

      Mailjet::Send.create(messages: [{
        'From'=> {
          'Email'=> "hello@mesateliersdiy.fr",
          'Name'=> "Mes ateliers DIY"
        },
        'To'=> [
          {
            'Email'=> creator.email,
          }
        ],
        'TemplateID'=> 2508109,
        'TemplateLanguage'=> true,
        'Subject'=> "Nouvelle réservation pour l'atelier #{workshop.title} ",
        'Variables'=> {
          "workshop_title" => workshop.title,
          "first_name" => creator.first_name,
          "workshop_date" => I18n.l(booking.workshop_event.start_time.to_date),
          "customer_name" => "#{booking.first_name} #{booking.last_name}",
          "price" => "#{Money.new(booking.total_price_cents)}€",
        }
      }])
    end
  end
end
