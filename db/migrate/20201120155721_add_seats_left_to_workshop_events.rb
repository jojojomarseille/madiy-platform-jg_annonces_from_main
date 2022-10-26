class AddSeatsLeftToWorkshopEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :workshop_events, :seats_left, :integer, null: false, default: 0
  end
end
