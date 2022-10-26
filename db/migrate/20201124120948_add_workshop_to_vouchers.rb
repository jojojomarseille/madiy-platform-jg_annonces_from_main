class AddWorkshopToVouchers < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_reference :vouchers, :workshop, type: :uuid, index: {algorithm: :concurrently}
  end
end
