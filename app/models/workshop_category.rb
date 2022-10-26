class WorkshopCategory < ApplicationRecord
  has_many :workshops, inverse_of: :category, foreign_key: :category_id

  validates :name, :color, presence: true
end
