class AddShipmentToWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :shipment, :boolean, default: false, null: false
  end
end
