class AddGeolocationIndexToAddresses < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :addresses, %i[latitude longitude], algorithm: :concurrently
  end
end
