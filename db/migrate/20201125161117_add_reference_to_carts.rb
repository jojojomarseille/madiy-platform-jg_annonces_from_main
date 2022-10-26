class AddReferenceToCarts < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :reference, :integer, index: { unique: true }
  end
end
