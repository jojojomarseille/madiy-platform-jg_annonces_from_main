class AddShippingModeEnum < ActiveRecord::Migration[6.0]
  def up
    safety_assured {
      execute <<-SQL
        CREATE TYPE shipping_mode AS ENUM ('no_shipping', 'shipping', 'click_and_collect');
      SQL
    }
  end

  def down
    safety_assured {
      execute <<-SQL
        DROP TYPE shipping_mode;
      SQL
    }
  end
end
