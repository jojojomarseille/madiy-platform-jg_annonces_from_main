class AddStateToCarts < ActiveRecord::Migration[6.0]
  def up
    safety_assured do
      execute <<-SQL
        CREATE TYPE cart_state AS ENUM ('picking', 'pending', 'paid', 'failed');
      SQL
    end

    add_column :carts, :state, :cart_state, null: false, default: "picking", index: true
  end

  def down
    safety_assured do
      execute <<-SQL
        DROP TYPE cart_state;
      SQL
    end

    remove_column :carts, :state, :cart_state
  end
end
