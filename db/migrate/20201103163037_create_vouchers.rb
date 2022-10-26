class CreateVouchers < ActiveRecord::Migration[6.0]
  def change
    create_table :vouchers, id: :uuid do |t|
      t.integer :amount_cents, null: false, default: 0, index: true

      t.timestamps
    end
  end
end
