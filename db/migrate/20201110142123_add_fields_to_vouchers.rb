class AddFieldsToVouchers < ActiveRecord::Migration[6.0]
  def change
    add_column :vouchers, :from, :string, null: false
    add_column :vouchers, :to, :string, null: false
    add_column :vouchers, :message, :text
  end
end
