class CreatorContact < ApplicationRecord
  validates :name, :email, :phone_number, :workshop_category, :city, :website, :message, presence: true

  scope :recent, -> (limit) { order(created_at: :desc).limit(limit) }
end
