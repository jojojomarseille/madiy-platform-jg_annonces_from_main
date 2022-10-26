module Mailers
  class WorkshopBookedJob < ApplicationJob
    queue_as :default

    def perform(booking:, cart:)
      customer = cart.user
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
        'TemplateID'=> 2010835,
        'TemplateLanguage'=> true,
        'Subject'=> "Nouvelle réservation pour votre atelier",
        'Variables'=> {
          "first_name" => creator.first_name,
          "workshop_title" => workshop.title,
          "reference" => cart.public_reference,
          "date" => I18n.l(cart.paid_at),
          "workshop_date" => I18n.l(booking.workshop_event.start_time.to_date),
          "customer_name" => "#{customer.first_name} #{customer.last_name}",
          "seats" => booking.seats,
          "price" => "#{Money.new(booking.price_cents / booking.seats)}€",
          "total_price" => "#{Money.new(booking.total_price_cents)}€"
        }
      }])
    end
  end
end
