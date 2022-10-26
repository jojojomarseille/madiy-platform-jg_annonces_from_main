class AddCompanyToCreators < ActiveRecord::Migration[6.0]
  def change
    add_column :creators, :company, :string
  end
end
