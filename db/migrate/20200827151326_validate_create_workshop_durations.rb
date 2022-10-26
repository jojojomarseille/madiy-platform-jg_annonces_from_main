class ValidateCreateWorkshopDurations < ActiveRecord::Migration[6.0]
  def change
    validate_foreign_key :workshop_durations, :workshops
  end
end
