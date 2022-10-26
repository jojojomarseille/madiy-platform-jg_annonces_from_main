class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings, id: :uuid do |t|
      t.references :workshop_event, type: :uuid, null: false, foreign_key: true
      t.integer :seats, null: false, default: 0
      t.boolean :active, null: false, default: false
      t.integer :price_cents, null: false, default: 0

      t.timestamps
    end

    add_column :bookings, :price_category, :workshop_price_category, null: false, default: "adult", index: true
  end
end
