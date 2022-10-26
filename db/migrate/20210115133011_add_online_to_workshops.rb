class AddOnlineToWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :online, :boolean, default: false, null: false
  end
end
