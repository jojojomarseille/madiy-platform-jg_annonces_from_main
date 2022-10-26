namespace :zones do
  desc "Create a default zone and attach workshops to it"
  task attach_workshops: :environment do
    break if Zone.any?

    ActiveRecord::Base.transaction do
      zone = Zone.create!(name: "La Rochelle")
      Workshop.update_all(zone_id: zone.id)

      Zone.create!(name: "Rochefort")
    end
  end
end
