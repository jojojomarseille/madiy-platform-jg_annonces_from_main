class AddCanceledToWorkshopEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :workshop_events, :canceled, :boolean
  end
end
