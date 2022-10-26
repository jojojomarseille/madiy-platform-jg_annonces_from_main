class CreateSpecificWorkshopContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :specific_workshop_contacts, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone_number, null: false
      t.string :workshop_category, null: false
      t.string :seats, null: false
      t.text :message, null: false

      t.timestamps
    end
  end
end
