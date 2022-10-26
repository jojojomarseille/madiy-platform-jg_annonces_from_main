class Coupon < ApplicationRecord
  before_validation :set_token, on: :create, unless: :token

  belongs_to :couponable, polymorphic: true

  validates :token, presence: true

  scope :active, -> { where(active: true) }

  def token=(token)
    super(token&.downcase)
  end

  private

  def set_token
    self.token = generate_token
  end

  def generate_token
    loop do
      token = SecureRandom.hex(5)
      break token unless self.class.exists?(token: token)
    end
  end
end
