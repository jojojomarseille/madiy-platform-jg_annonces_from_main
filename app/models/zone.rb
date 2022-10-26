class Zone < ApplicationRecord
  validates :name, presence: true

  has_many :workshops
end
