class ChangeTransactionIdTypeFromCarts < ActiveRecord::Migration[6.0]
  def change
    change_column :carts, :transaction_id, :string
  end
end
