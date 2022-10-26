class CreateWorkshopCategories < ActiveRecord::Migration[6.0]
  def up
    create_table :workshop_categories, id: :uuid do |t|
      t.string :name, null: false
      t.string :color, null: false

      t.timestamps
    end

    add_column :workshops, :category_id, :uuid, null: false
    add_foreign_key :workshops, :workshop_categories, column: :category_id, validate: false
  end

  def down
    remove_column :workshops, :category_id
    drop_table :workshop_categories
  end
end
