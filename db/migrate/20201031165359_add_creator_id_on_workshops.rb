class AddCreatorIdOnWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :creator_id, :uuid
    add_foreign_key :workshops, :creators, validate: false
  end
end
