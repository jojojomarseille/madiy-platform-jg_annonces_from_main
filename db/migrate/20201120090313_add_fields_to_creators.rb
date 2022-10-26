class AddFieldsToCreators < ActiveRecord::Migration[6.0]
  def change
    add_column :creators, :website, :string
    add_column :creators, :facebook, :string
    add_column :creators, :instagram, :string
    add_column :creators, :bio, :text
  end
end
