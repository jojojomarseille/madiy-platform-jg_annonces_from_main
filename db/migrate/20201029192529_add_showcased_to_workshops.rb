class AddShowcasedToWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :showcased, :boolean, null: false, default: false
  end
end
