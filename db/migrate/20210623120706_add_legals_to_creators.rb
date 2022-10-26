class AddLegalsToCreators < ActiveRecord::Migration[6.0]
  def change
    add_column :creators, :legal_statut, :string
    add_column :creators, :tva, :boolean
    add_column :creators, :tva_num, :string
  end
end
