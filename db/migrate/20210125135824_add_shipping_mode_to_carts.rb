class AddShippingModeToCarts < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :shipping_mode, :shipping_mode, default: 'no_shipping', null: false
  end
end
