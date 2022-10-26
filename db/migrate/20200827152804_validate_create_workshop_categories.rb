class ValidateCreateWorkshopCategories < ActiveRecord::Migration[6.0]
  def change
    validate_foreign_key :workshops, :workshop_categories
  end
end
