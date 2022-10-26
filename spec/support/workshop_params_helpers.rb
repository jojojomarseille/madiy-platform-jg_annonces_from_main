module WorkshopParamsHelper
  def valid_workshop_params(category, creator, zone)
    attributes_for(:workshop).merge(
      category_id: category.id,
      creator_id: creator.id,
      zone_id: zone.id,
      seats: 10,
      title: "test",
      goal: "test",
      description: "test",
      audience: "adult",
      workshop_duration_attributes: attributes_for(:workshop_duration),
      address_attributes: attributes_for(:address),
      workshop_events_attributes: [attributes_for(:workshop_event)],
      workshop_prices_attributes: [attributes_for(:workshop_price)]
    )
  end

  def invalid_workshop_params
    attributes_for(:workshop)
  end
end

RSpec.configure do |c|
  c.include WorkshopParamsHelper
end
