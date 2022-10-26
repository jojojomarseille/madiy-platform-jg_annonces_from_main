class Booking < ApplicationRecord
  enum price_category: {
    adult: "adult",
    child: "child",
    adult_and_child: "adult_and_child",
    reduced: "reduced"
  }

  belongs_to :workshop_event
  has_one :workshop, through: :workshop_event
  has_one :creator, through: :workshop

  has_one :cart_item, as: :cartable
  has_one :cart, through: :cart_item
  has_one :user, through: :cart

  validates :seats, :price_cents, presence: true
  validates :seats, numericality: {greater_than: 0}

  monetize :price_cents

  scope :booked_by_admin, -> { where(booked_by_admin: true) }
  scope :paid, -> { left_joins(:cart).merge(Cart.paid).or(left_joins(:cart).booked_by_admin) }
  scope :unpaid, -> { joins(:cart).merge(Cart.picking) }
  scope :active, -> { where(active: true) }
  scope :for_event, -> (event) { where(workshop_event: event) }

  def self.shipments?
    joins(:workshop).exists?(workshops: { shipment: true })
  end

  def self.shipments
    joins(:workshop).where(workshops: { shipment: true })
  end

  def self.shipments_with_click_and_collect?
    joins(workshop: :creator).exists?(workshops: { shipment: true }, creators: { click_and_collect: true })
  end

  def self.shipments_with_click_and_collect
    joins(workshop: :creator).find_by(workshops: { shipment: true }, creators: { click_and_collect: true })
  end

  def to_s
    "Réservation pour l'atelier #{workshop.title}"
  end

  def amount_cents
    price_cents
  end
# les reservations (bookings) créé par un admin ne sont pas lié a un user, donc on check si la resa est liée a un user et on prend le nom de l user ou celui indiqué suivant les cas
  def combined_first_name
    user&.first_name || first_name.presence || "anonyme"
  end

  def combined_last_name
    user&.last_name || last_name.presence || "anonyme"
  end

  def total_price_cents
    price_cents * seats
  end

  def activate!
    transaction do
      workshop_event.update!(seats_left: workshop_event.seats_left - seats)
      update!(active: true)
    end
  end

  def deactivate!
    transaction do
      workshop_event.update!(seats_left: workshop_event.seats_left + seats)
      update!(active: false)
    end
  end
end
