class AddIndexOnMangopayIdToUsers < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :users, :mangopay_id, algorithm: :concurrently
  end
end
