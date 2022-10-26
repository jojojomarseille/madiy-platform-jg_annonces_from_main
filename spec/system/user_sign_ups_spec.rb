# require "rails_helper"

# RSpec.describe "UserSignUps", type: :system do
#   before do
#     driven_by(:rack_test)
#     expect(MangoPay::NaturalUser).to receive(:create).and_return({"Id" => 222})
#     expect(MangoPay::Wallet).to receive(:create)
#   end

#   it "as a user, I can sign up to the platform" do
#     visit "/mon-compte/sign_up"

#     within ".form-compte" do
#       fill_in "Email", with: "an_email@example.com"
#       fill_in "Mot de passe", with: "password"
#       fill_in "Confirmation", with: "password"
#     end

#     expect { click_on "S'inscrire" }.not_to change { User.count }

#     expect(page).to have_content("Prénom doit être rempli(e)")
#     expect(page).to have_content("Nom doit être rempli(e)")

#     within ".form-compte" do
#       fill_in "Prénom", with: "John"
#       fill_in "Nom", with: "Doe"
#       fill_in "Mot de passe", with: "password"
#       fill_in "Confirmation", with: "password"
#     end

#     expect { click_on "S'inscrire" }.to change { User.count }.by(1)
#   end
# end
