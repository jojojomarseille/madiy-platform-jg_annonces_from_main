class CreateShipments < ActiveRecord::Migration[6.0]
  def change
    create_table :shipments, id: :uuid do |t|
      t.uuid :cart_id, null: false, foreign_key: true, index: true
      t.boolean :shipped, default: false, null: false
      t.string :token, index: { unique: true }, null: false

      t.timestamps
    end
  end
end
