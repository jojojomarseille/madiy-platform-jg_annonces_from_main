class AddMangoFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :birthday, :date, null: false
    add_column :users, :mangopay_id, :integer, index: true
  end
end
