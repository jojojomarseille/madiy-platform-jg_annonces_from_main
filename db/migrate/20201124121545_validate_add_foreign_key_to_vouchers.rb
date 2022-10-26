class ValidateAddForeignKeyToVouchers < ActiveRecord::Migration[6.0]
  def change
    validate_foreign_key :vouchers, :workshops
  end
end
