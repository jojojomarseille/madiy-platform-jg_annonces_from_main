class CreateDiscounts < ActiveRecord::Migration[6.0]
  def change
    create_table :discounts, id: :uuid do |t|
      t.integer :amount_cents, null: false
      t.references :voucher, type: :uuid, null: false, foreign_key: true
      t.references :cart, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
