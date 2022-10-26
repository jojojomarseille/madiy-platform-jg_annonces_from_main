class WorkshopEvent < ApplicationRecord
  before_validation :set_end_time, on: :create, if: :workshop
  before_validation :set_seats_left, on: :create, if: :workshop
  before_save :set_end_time, if: :workshop

  before_destroy :clean_unpaid_bookings

  belongs_to :workshop, inverse_of: :workshop_events

  # include DateTimeAttribute
  # attr_accessor :start_time
  # date_time_attribute :start_time

  has_many :bookings, -> { paid }

  validates :seats_left, :start_time, :end_time, presence: true
  validates :seats_left, numericality: {greater_than_or_equal_to: 0, message: "insuffisantes pour valider ces réservations"}
  validates :start_time, date: {before: :end_time}, if: :end_time
  validates :start_time, date: {after: proc { Time.current }}

  scope :in_future, -> { not_canceled.where("workshop_events.start_time > ?", Time.current) }
  scope :until, -> (date) { where("workshop_events.start_time <= ?", date)}
  scope :not_canceled, -> { where(canceled_at: nil) }

  def canceled?
    canceled_at.present?
  end

  def future?
    return false unless [start_time, end_time].all?
    start_time.future? && end_time.future?
  end

  def to_s
    "Date pour l'atelier #{workshop.title} du #{I18n.l(start_time, format: :event)}"
  end

  def total_seats
    return self.seats_reserved + self.seats_left
  end

  def cancelable?
    if self.seats_reserved > 0
      return false
    elsif self.start_time < Time.now
      return false
    else
      return true
    end
  end

  def seats_reserved
    return Booking.active.for_event(self).map {|s| s['seats']}.reduce(0, :+)
  end

  def total_sold
   return Booking.where(workshop_event_id: self.id).map {|s| s['price_cents']}.reduce(0, :+)
  end

  def total_sales_event_humanized
    bookings_amounts = []
    Booking.active.for_event(self).each do |booking|
    bookings_amounts << booking.total_price_cents
    end
    return "#{bookings_amounts.reduce(0, :+)/100}€"
  end

  def amount_humanized
    return "#{self.total_sold/100}€"
  end

  private

  def set_end_time
    self.end_time = start_time + workshop.workshop_duration.total
  rescue TypeError
    errors.add(:end_time, "ne peut être déduite sans durée associée")
  rescue NoMethodError
    errors.add(:start_time, :required)
  end

  def set_seats_left
    if self.canceled == true
      self.seats_left = 0
    else
      self.seats_left = workshop.seats
    end
  end

  def clean_unpaid_bookings
    Booking.where(workshop_event: self).unpaid.destroy_all
  end
end
