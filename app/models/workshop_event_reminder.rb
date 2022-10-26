class WorkshopEventReminder < ApplicationRecord
  belongs_to :workshop

  validates :email, presence: true, format: { with: Devise.email_regexp }, uniqueness: { scope: :workshop_id, message: "déjà inscrit à cette alerte" }
end
