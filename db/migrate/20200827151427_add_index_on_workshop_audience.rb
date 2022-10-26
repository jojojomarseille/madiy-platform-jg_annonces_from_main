class AddIndexOnWorkshopAudience < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :workshops, :audience, algorithm: :concurrently
  end
end
