class AddIndexesOnForeignKeys < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!
  def change
    add_index :workshop_durations, :workshop_id, algorithm: :concurrently
    add_index :workshop_prices, :workshop_id, algorithm: :concurrently
    add_index :workshops, :category_id, algorithm: :concurrently
  end
end
