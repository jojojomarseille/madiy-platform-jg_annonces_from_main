class AddVisibleToWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :visible, :boolean, null: false, default: false, index: true
  end
end
