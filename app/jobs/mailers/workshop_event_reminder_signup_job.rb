module Mailers
  class WorkshopEventReminderSignupJob < ApplicationJob
    queue_as :default

    def perform(reminder:)
      workshop = reminder.workshop
      email = reminder.email
      user = User.find_by(email: email)

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
        'TemplateID'=> 1875948,
        'TemplateLanguage'=> true,
        'Subject'=> "Confirmation envoi formulaire des prochaines dates d'atelier",
        'Variables'=> {
          "first_name" => user ? user.first_name : "",
          "created_at" => I18n.l(Time.current, format: :short),
          "email" => email,
          "workshop_title" => workshop.title,
        }
      }])
    end
  end
end
