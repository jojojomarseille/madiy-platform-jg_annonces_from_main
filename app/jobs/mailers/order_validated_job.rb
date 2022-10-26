module Mailers
  class OrderValidatedJob < ApplicationJob
    queue_as :default

    def perform(cart:)
      user = cart.user

      Mailjet::Send.create(messages: [{
        'From'=> {
          'Email'=> "hello@mesateliersdiy.fr",
          'Name'=> "Mes ateliers DIY"
        },
        'To'=> [
          {
            'Email'=> user.email,
          }
        ],
        'TemplateID'=> 1875828,
        'TemplateLanguage'=> true,
        'Subject'=> "✨  Confirmation de commande n°#{cart.public_reference} !",
        'Variables'=> {
          "first_name" => user.first_name,
          "date" => I18n.l(cart.paid_at, format: :short),
          "reference" => cart.public_reference,
          "items" => cart.cart_items.map do |item|
            {
              "name" => item_name(item),
              "quantity" => item.quantity,
              "price" => "#{Money.new(item.cartable.amount_cents)}€",
              "total_price" => "#{Money.new(item.amount_cents)}€"
            }
          end,
          "total_price" => "#{Money.new(cart.amount_cents)}€"
        }
      }])
    end

    private

    def item_name(item)
      case item.cartable_type
      when "Booking"
        item.cartable.workshop_event.workshop.title
      when "Voucher"
        if item.cartable.workshop.present?
          "Bon cadeau pour l'atelier #{item.cartable.workshop.title}"
        else
          "Bon cadeau d'une valeur de #{Money.new(item.cartable.amount_cents)}€"
        end
      end
    end
  end
end
