class AddPaidAtToCarts < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :paid_at, :datetime
  end
end
