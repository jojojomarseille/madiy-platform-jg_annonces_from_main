class AddApprovedToCreators < ActiveRecord::Migration[6.0]
  def change
    add_column :creators, :approved, :boolean
  end
end
