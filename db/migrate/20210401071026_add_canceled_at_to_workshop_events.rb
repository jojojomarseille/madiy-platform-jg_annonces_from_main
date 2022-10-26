class AddCanceledAtToWorkshopEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :workshop_events, :canceled_at, :datetime
  end
end
