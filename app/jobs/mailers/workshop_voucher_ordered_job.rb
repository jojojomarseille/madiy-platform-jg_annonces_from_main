module Mailers
  class WorkshopVoucherOrderedJob < ApplicationJob
    queue_as :default

    def perform(voucher:, cart:)
      workshop = voucher.workshop
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
        'TemplateID'=> 2152787,
        'TemplateLanguage'=> true,
        'Subject'=> "Confirmation envoi formulaire des prochaines dates d'atelier",
        'Variables'=> {
          "first_name" => creator.first_name,
          "workshop_title" => workshop.title,
          "reference" => cart.public_reference,
          "date" => I18n.l(cart.paid_at),
          "price" => "#{Money.new(voucher.amount_cents)}€"
        }
      }])
    end
  end
end
