class AddActiveToCoupons < ActiveRecord::Migration[6.0]
  def change
    add_column :coupons, :active, :boolean, null: false, default: false, index: true
  end
end
