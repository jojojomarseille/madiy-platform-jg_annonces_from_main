class AddOptionsToVouchers < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_column :vouchers, :minimum_amount_cents, :integer
    add_column :vouchers, :max_uses, :integer
    add_column :vouchers, :max_uses_by_user, :integer
    add_column :vouchers, :user_id, :uuid
    
    add_index :vouchers, :user_id, algorithm: :concurrently
  end
end
