class AddSeatsToWorkshopPrices < ActiveRecord::Migration[6.0]
  def change
    add_column :workshop_prices, :seats, :integer, null: false, default: 1
  end
end
