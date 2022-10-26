class CreateWorkshopPrices < ActiveRecord::Migration[6.0]
  def up
    create_table :workshop_prices, id: :uuid do |t|
      t.string :name, null: false
      t.monetize :price, null: false, default: 0
      t.uuid :workshop_id, null: false

      t.timestamps
    end

    add_foreign_key :workshop_prices, :workshops, column: :workshop_id, validate: false
  end

  def down
    drop_table :workshop_prices
  end
end
