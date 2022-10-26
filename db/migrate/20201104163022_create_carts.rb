class CreateCarts < ActiveRecord::Migration[6.0]
  def change
    create_table :carts, id: :uuid do |t|
      t.timestamps
    end
  end
end
