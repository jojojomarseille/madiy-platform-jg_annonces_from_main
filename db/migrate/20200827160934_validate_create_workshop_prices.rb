class ValidateCreateWorkshopPrices < ActiveRecord::Migration[6.0]
  def change
    validate_foreign_key :workshop_prices, :workshops
  end
end
