module Mailers
  class ShipmentReadyJob < ApplicationJob
    queue_as :default

    def perform(shipment:)
      cart = shipment.cart
      customer = cart.user
      booking = shipment.shipment_lines.find_by(shippable_type: "Booking").shippable
      workshop = booking.workshop
      creator = workshop.creator

      Mailjet::Send.create(messages: [{
        'From'=> {
          'Email'=> "hello@mesateliersdiy.fr",
          'Name'=> "Mes ateliers DIY"
        },
        'To'=> [
          {
            'Email'=> customer.email,
          }
        ],
        'TemplateID'=> 2321603,
        'TemplateLanguage'=> true,
        'Subject'=> "Votre kit #{shipment.click_and_collect? ? "est prêt à être retiré" : "a été expédié"}",
        'Variables'=> {
          "first_name" => customer.first_name,
          "workshop_title" => workshop.title,
          "workshop_date" => I18n.l(booking.workshop_event.start_time.to_date),
          "shipping_mode" => shipment.click_and_collect? ? "click_and_collect" : "shipping"
        }
      }])
    end
  end
end
