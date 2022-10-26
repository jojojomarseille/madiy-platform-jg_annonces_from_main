class CreateShipmentLines < ActiveRecord::Migration[6.0]
  def change
    create_table :shipment_lines, id: :uuid do |t|
      t.references :shipment, type: :uuid, null: false, foreign_key: true

      t.uuid :shippable_id, null: false
      t.string :shippable_type, null: false

      t.timestamps
    end

    add_index :shipment_lines, %i[shippable_id shippable_type]
  end
end
