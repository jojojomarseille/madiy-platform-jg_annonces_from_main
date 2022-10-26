class AddIndexForCreatorOnWorkshops < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :workshops, :creator_id, algorithm: :concurrently
  end
end
