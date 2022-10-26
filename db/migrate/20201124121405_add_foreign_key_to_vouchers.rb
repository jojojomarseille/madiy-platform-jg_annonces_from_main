class AddForeignKeyToVouchers < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :vouchers, :workshops, column: :workshop_id, validate: false
  end
end
