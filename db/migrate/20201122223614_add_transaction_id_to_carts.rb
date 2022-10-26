class AddTransactionIdToCarts < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :transaction_id, :integer, index: true
  end
end
