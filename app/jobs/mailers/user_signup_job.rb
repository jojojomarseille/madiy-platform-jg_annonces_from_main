module Mailers
  class UserSignupJob < ApplicationJob
    queue_as :default

    def perform(user:)
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
        'TemplateID'=> 1875716,
        'TemplateLanguage'=> true,
        'Subject'=> "👋  Bienvenue sur Mes ateliers DIY! ",
        'Variables'=> {
          "first_name" => user.first_name,
          "email" => user.email,
        }
      }])
    end
  end
end
