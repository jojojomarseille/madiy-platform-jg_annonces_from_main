class AddSeatsToWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :seats, :integer, null: false
  end
end
