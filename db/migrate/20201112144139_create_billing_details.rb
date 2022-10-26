class CreateBillingDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :billing_details, id: :uuid do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone_number, null: false
      t.string :company
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
