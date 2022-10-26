class AddUserToCarts < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!
  def change
    add_reference :carts, :user, type: :uuid, index: {algorithm: :concurrently}
  end
end
