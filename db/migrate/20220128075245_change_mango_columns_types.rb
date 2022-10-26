class ChangeMangoColumnsTypes < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      change_column :users, :mangopay_id, :string
      change_column :carts, :transaction_id, :string
    end
  end
end
