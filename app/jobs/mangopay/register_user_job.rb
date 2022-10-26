module Mangopay
  class RegisterUserJob < ApplicationJob
    queue_as :default

    ISO_FR = -"FR"
    ISO_EUR = -"EUR"

    def perform(user:)
      response = MangoPay::NaturalUser.create({
        "FirstName" => user.first_name,
        "LastName" => user.last_name,
        "Birthday" => user.birthday.to_datetime.to_i,
        "Nationality" => ISO_FR,
        "CountryOfResidence" => ISO_FR,
        "Email" => user.email
      })

      user.update!(mangopay_id: response["Id"])

      MangoPay::Wallet.create({
        "Owners" => [response["Id"]],
        "Description" => "Wallet par défaut",
        "Currency" => ISO_EUR
      })
    end
  end
end
