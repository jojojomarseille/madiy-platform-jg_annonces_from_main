# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless WorkshopCategory.any?
  {
    "Art" => "#ed4356",
    "Bien-être" => "#56d8cf",
    "Craft" => "#8668c4",
    "Culinaire" => "#ff8500",
    "Home décor" => "#ff931e",
    "Nature" => "#0b3fc1",
    "Textile" => "#f57184",
    "Zéro déchet" => "#3ba66f"
  }.each { |name, color| WorkshopCategory.create!(name: name, color: color) }
end

Z1 = Zone.create(name: "Nante2")

d1 = DateTime.new(2001, 6, 22)

AdminUser.create!(email: "admin11@example.com", password: "password", password_confirmation: "password") if Rails.env.development?
User.create!(email:"a3@a.fr", password: "password", password_confirmation: "password", first_name: "testfirstname", last_name: "testlastname", birthday: d1 )
User.create!(email:"b3@b.fr", password: "password", password_confirmation: "password", first_name: "testfirstname2", last_name: "testlastname2", birthday: d1 )
# WorkshopCategories.create()
roger = Workshop.create(title: "test55", goal: "test", workshop_events_attributes: {start_time: "2021-06-10" , end_time: "2021-06-10"}, description: "test", more: "test", seats: 10, audience: "adult", category_id: "cb743eca-c8f3-4527-8975-fb5712c3daaa", giftable: 1, online: 0, zone_id: "1b824e61-b226-4221-a2cc-7fcd2a477e79", creator_id: "f46a1663-49cf-45fe-9b29-2e3f238e260a")
, workshop_events_attributes: {start_time: "2021-06-10" , end_time: "2021-06-10"}
workshop_prices_attributes: {category: "adult", price: 1000}, address_attributes: {street: "rue des moulins", postal_code: "13002", city:"marseille"}