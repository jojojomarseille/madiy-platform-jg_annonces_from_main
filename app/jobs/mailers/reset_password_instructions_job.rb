module Mailers
  class ResetPasswordInstructionsJob < ApplicationJob
    queue_as :default

    def perform(user:, url:)
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
        'TemplateID'=> 1875931,
        'TemplateLanguage'=> true,
        'Subject'=> "Réinitialisation de votre mot de passe",
        'Variables'=> {
          "first_name" => user.first_name,
          "cta_link" => url,
        }
      }])
    end
  end
end
