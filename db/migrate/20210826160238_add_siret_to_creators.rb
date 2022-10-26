class AddSiretToCreators < ActiveRecord::Migration[6.0]
  def change
    add_column :creators, :siret, :string
  end
end
