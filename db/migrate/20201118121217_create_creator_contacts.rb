class CreateCreatorContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :creator_contacts, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone_number, null: false
      t.string :workshop_category, null: false
      t.string :city, null: false
      t.string :website, null: false
      t.text :message, null: false

      t.timestamps
    end
  end
end
