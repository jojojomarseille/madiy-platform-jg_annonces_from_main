class ChangeMangoPayIdTypeFromUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :mangopay_id, :string
  end
end
