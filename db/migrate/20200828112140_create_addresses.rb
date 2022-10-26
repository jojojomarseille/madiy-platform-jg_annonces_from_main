class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses, id: :uuid do |t|
      t.string :street, null: false
      t.string :postal_code, null: false
      t.string :city, null: false
      t.uuid :addressable_id, null: false
      t.string :addressable_type, null: false

      t.timestamps
    end

    add_index :addresses, %i[addressable_id addressable_type]
  end
end
