class CreateWorkshopEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_events, id: :uuid do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.references :workshop, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
