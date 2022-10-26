class CreateWorkshopEventReminders < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_event_reminders, id: :uuid do |t|
      t.string :email, null: false
      t.references :workshop, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end

    add_index :workshop_event_reminders, %i[email workshop_id], unique: true
  end
end
