class AddEmailToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :email, :string
  end
end
