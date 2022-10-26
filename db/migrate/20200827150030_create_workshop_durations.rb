class CreateWorkshopDurations < ActiveRecord::Migration[6.0]
  def up
    create_table :workshop_durations, id: :uuid do |t|
      t.integer :hours, null: false
      t.integer :minutes, null: false
      t.uuid :workshop_id, null: false

      t.timestamps
    end

    add_foreign_key :workshop_durations, :workshops, column: :workshop_id, validate: false
  end

  def down
    drop_table :workshop_durations
  end
end
