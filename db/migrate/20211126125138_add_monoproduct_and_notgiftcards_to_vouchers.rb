class AddMonoproductAndNotgiftcardsToVouchers < ActiveRecord::Migration[6.0]
  def change
    add_column :vouchers, :monoproduct, :boolean
    add_column :vouchers, :notgiftcards, :boolean
  end
end
