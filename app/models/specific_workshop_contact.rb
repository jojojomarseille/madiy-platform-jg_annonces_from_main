class SpecificWorkshopContact < ApplicationRecord
  validates :name, :email, :phone_number, :workshop_category, :seats, :message, presence: true

  scope :recent, -> (limit) { order(created_at: :desc).limit(limit) }
end
