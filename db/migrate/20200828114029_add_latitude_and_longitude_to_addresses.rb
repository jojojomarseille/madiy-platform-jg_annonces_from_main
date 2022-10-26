class AddLatitudeAndLongitudeToAddresses < ActiveRecord::Migration[6.0]
  def change
    add_column :addresses, :latitude, :decimal, precision: 10, scale: 6
    add_column :addresses, :longitude, :decimal, precision: 10, scale: 6
  end
end
