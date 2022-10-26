class AddHideEndTimeToWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :hide_end_time, :boolean, null: false, default: false
  end
end
