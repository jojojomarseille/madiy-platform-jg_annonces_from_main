module Mailers
  class ShipmentPreparedJob < ApplicationJob
    include Rails.application.routes.url_helpers

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
            'Email'=> creator.email,
          }
        ],
        'TemplateID'=> 2229010,
        'TemplateLanguage'=> true,
        'Subject'=> "Nouvelle réservation pour l'atelier en visio",
        'Variables'=> {
          "first_name" => creator.first_name,
          "workshop_title" => workshop.title,
          "reference" => cart.public_reference,
          "date" => I18n.l(cart.paid_at),
          "workshop_date" => I18n.l(booking.workshop_event.start_time.to_date),
          "customer_name" => "#{customer.first_name} #{customer.last_name}",
          "price" => "#{Money.new(booking.total_price_cents)}€",
          "cta_link" => edit_shipment_url(shipment, token: shipment.token),
          "shipping_mode" => shipment.click_and_collect? ? "click_and_collect" : "shipping"
        }
      }])
    end

    private

    def default_url_options
      Rails.application.config.x.active_job.default_url_options
    end
  end
end
