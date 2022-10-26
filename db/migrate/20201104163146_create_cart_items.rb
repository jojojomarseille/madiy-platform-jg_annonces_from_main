class CreateCartItems < ActiveRecord::Migration[6.0]
  def change
    create_table :cart_items, id: :uuid do |t|
      t.uuid :cartable_id, null: false
      t.string :cartable_type, null: false

      t.references :cart, null: false, foreign_key: true, type: :uuid

      t.integer :quantity, null: false, default: 1

      t.timestamps
    end

    add_index :cart_items, %i[cart_id cartable_id cartable_type], unique: true
    add_index :cart_items, %i[cartable_id cartable_type]
  end
end
