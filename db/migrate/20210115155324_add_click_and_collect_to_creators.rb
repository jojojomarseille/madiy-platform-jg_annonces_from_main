class AddClickAndCollectToCreators < ActiveRecord::Migration[6.0]
  def change
    add_column :creators, :click_and_collect, :boolean, default: false, null: false
  end
end
