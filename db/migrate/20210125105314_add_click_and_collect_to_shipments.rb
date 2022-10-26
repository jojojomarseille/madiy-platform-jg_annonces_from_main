class AddClickAndCollectToShipments < ActiveRecord::Migration[6.0]
  def change
    add_column :shipments, :click_and_collect, :boolean, default: false, null: false
  end
end
