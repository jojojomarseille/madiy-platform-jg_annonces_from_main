class WorkshopPrice < ApplicationRecord
  self.ignored_columns = ["name"]

  belongs_to :workshop, inverse_of: :workshop_prices

  enum category: {
    adult: "adult",
    child: "child",
    adult_and_child: "adult_and_child",
    reduced: "reduced"
  }, _suffix: true

  validates :price_cents, presence: true
  validates :price_cents, numericality: {greater_than_or_equal_to: 0}
  validates :category, inclusion: {in: categories.keys}

  monetize :price_cents
end
