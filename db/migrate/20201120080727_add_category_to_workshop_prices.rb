class AddCategoryToWorkshopPrices < ActiveRecord::Migration[6.0]
  def up
    safety_assured do
      execute <<-SQL
        CREATE TYPE workshop_price_category AS ENUM ('adult', 'child', 'adult_and_child', 'reduced');
      SQL
    end

    add_column :workshop_prices, :category, :workshop_price_category, null: false, default: "adult", index: true
  end

  def down
    safety_assured do
      execute <<-SQL
        DROP TYPE workshop_price_category;
      SQL
    end

    remove_column :workshop_prices, :category, :workshop_price_category
  end
end
