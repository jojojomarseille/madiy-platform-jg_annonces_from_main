class ValidateAddCreatorIdOnWorkshops < ActiveRecord::Migration[6.0]
  def change
    validate_foreign_key :workshops, :creators
  end
end
