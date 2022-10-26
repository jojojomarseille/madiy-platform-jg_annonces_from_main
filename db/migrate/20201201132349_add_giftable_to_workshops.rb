class AddGiftableToWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :giftable, :boolean, null: false, default: true
  end
end
