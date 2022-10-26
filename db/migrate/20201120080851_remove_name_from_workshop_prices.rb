class RemoveNameFromWorkshopPrices < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_column :workshop_prices, :name, :string }
  end
end
