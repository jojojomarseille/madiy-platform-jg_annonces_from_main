class AddZoneIdToWorkshops < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_reference :workshops, :zone, type: :uuid, index: {algorithm: :concurrently}
  end
end
