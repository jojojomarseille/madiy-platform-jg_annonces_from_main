class AddStatutToWorkshop < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :statut, :string
    change_column_default :workshops, :statut, "Soumis"
  end
end
