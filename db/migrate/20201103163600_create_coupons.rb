class CreateCoupons < ActiveRecord::Migration[6.0]
  def change
    create_table :coupons, id: :uuid do |t|
      t.string :token, null: false
      t.uuid :couponable_id, null: false
      t.string :couponable_type, null: false

      t.timestamps
    end

    add_index :coupons, :token, unique: true
    add_index :coupons, %i[couponable_id couponable_type]
  end
end
