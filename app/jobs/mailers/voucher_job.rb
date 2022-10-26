module Mailers
  class VoucherJob < ApplicationJob
    include Rails.application.routes.url_helpers

    queue_as :default

    def perform(voucher:, cart:)
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
        'TemplateID'=> 1875978,
        'TemplateLanguage'=> true,
        'Subject'=> "🎁  Bon cadeau de votre commande n°#{cart.public_reference} ! ",
        'Variables'=> {
          "first_name" => user.first_name,
        },
        'Attachments'=> [
          {
            'ContentType'=> 'application/pdf',
            'Filename'=> 'bon_cadeau.pdf',
            'Base64Content'=> Base64.encode64(pdf_file(voucher))
          }
        ]
      }])
    end

    private

    def default_url_options
      Rails.application.config.x.active_job.default_url_options
    end

    def pdf_file(voucher)
      template_name = if voucher.workshop.present?
        "with_workshop"
      else
        "show"
      end

      template_path = "vouchers/#{template_name}"

      WickedPdf.new.pdf_from_string(
        ApplicationController.render(
          template: template_path,
          assigns: { voucher: voucher }
        ),
        disable_smart_shrinking: true,
        margin: {
          top: 0,
          bottom: 0,
          left: 0,
          right: 0
        }
      )
    end
  end
end
