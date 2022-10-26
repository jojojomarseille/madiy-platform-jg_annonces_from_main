class AddValidatedAtToWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :validated_at, :datetime
  end
end
