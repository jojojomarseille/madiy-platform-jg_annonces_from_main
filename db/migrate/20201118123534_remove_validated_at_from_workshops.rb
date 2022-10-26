class RemoveValidatedAtFromWorkshops < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_column :workshops, :validated_at }
  end
end
