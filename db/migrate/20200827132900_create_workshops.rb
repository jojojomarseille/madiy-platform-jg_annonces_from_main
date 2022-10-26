class CreateWorkshops < ActiveRecord::Migration[6.0]
  def change
    create_table :workshops, id: :uuid do |t|
      t.string :title, null: false
      t.text :goal, null: false
      t.text :description, null: false
      t.text :more
      t.column :audience, :workshop_audience, null: false

      t.timestamps
    end
  end
end
