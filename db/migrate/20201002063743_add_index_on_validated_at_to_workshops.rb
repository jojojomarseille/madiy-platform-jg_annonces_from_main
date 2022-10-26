class AddIndexOnValidatedAtToWorkshops < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :workshops, :validated_at, algorithm: :concurrently
  end
end
