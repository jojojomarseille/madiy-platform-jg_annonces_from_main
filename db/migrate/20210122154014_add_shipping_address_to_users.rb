class AddShippingAddressToUsers < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!
  def change
    add_reference :users, :address, type: :uuid, index: {algorithm: :concurrently}
  end
end
