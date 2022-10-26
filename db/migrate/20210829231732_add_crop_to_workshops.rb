class AddCropToWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :crop_x, :string
    add_column :workshops, :crop_y, :string
    add_column :workshops, :crop_width, :string
    add_column :workshops, :crop_height, :string
  end
end
