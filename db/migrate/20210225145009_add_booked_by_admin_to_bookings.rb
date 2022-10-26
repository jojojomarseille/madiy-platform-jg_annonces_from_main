class AddBookedByAdminToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :booked_by_admin, :boolean, default: false, null: false
  end
end
