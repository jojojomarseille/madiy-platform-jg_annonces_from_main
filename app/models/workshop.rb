class Workshop < ApplicationRecord
  DEFAULT_SHOWCASED_LIMIT = 8.freeze

  self.ignored_columns = ["validated_at"]

  belongs_to :creator
  belongs_to :category, class_name: "WorkshopCategory", inverse_of: :workshops
  belongs_to :zone, optional: true
# penser a enlever ", :dependent => :destroy" quand j'enleverrai le vrais delete pour passer en soft delete
  has_one :workshop_duration, class_name: "WorkshopDuration", inverse_of: :workshop, :dependent => :destroy
  has_one :address, as: :addressable, :dependent => :destroy
  has_one_attached :main_picture

  has_many :workshop_prices, class_name: "WorkshopPrice", inverse_of: :workshop, :dependent => :destroy
  has_many :workshop_events, class_name: "WorkshopEvent", inverse_of: :workshop, :dependent => :destroy
  has_many :workshop_event_reminders
  has_many :vouchers
  has_many_attached :pictures
  
  accepts_nested_attributes_for :workshop_duration, :address, :workshop_prices, :workshop_events, allow_destroy: true

  after_save :set_visibility, if: :statut_validé?
  after_save :set_invisibility, if: :statut_supprimé?
  after_save :set_invisibility, if: :statut_soumis?

  def set_visibility
    self.update_column(:visible, true)
  end

  def set_invisibility
    self.update_column(:visible, false)
  end

  def statut_validé?
    if self.statut == "Validé"
      return true
    else
      return false
    end
  end

  def statut_supprimé?
    if self.statut == "supprimé"
      return true
    else
      return false
    end
  end


  def statut_soumis?
    if self.statut == "Soumis"
      return true
    else
      return false
    end
  end

  def events_dates
    events_dates = []
    self.events.each do |event|
      if event.canceled != true
      events_dates << event.start_time
      end
    end
    return events_dates
  end

  def events_id_array
    @array = []
    self.events.each do |event|
      @array << event.id
    end
    return @array
  end

  def archivable? 
    events_futur_dates = []
    self.events_dates.each do |date|
      if date > Date.today 
        events_futur_dates << date
      else
      end
    end 
    if self.statut == "Brouillon"
      return true
    else
      if events_futur_dates.any? 
        return false
      else
        return true
      end 
    end
  end

  enum audience: {
    adult: "adult",
    child: "child",
    adult_and_child: "adult_and_child"
  }, _suffix: true

  enum statut: {
    Soumis: "Soumis",
    Validé: "Validé",
    Brouillon: "Brouillon",
    supprimé: "supprimé"
  }, _suffix: true

  delegate :total, to: :workshop_duration, prefix: true, allow_nil: true
  
  validates :title, :goal, :description, :audience, :seats, presence: true 
  validates :audience, inclusion: {in: audiences.keys}
  validates :seats, numericality: {greater_than: 0}
  validates :main_picture, attached: true


  scope :showcased, -> (limit = DEFAULT_SHOWCASED_LIMIT) { select("workshops.*", "workshop_events.start_time").enabled.with_future_workshop_events.limit(limit).order("workshop_events.start_time") }
  scope :visible, -> { enabled.giftable.left_joins(:workshop_events).or(enabled.with_future_workshop_events).distinct }
  scope :enabled, -> { where(visible: true) }
  scope :giftable, -> { where(giftable: true) }
  scope :with_future_workshop_events, -> { left_joins(:workshop_events).merge(WorkshopEvent.in_future)}
  scope :online, -> { where(online: true) }
  scope :by_category, -> (category) { where(category: category) }
  scope :by_zone, -> (zone) { where(zone: zone) }

  scope :related_to, -> (workshop, limit = DEFAULT_SHOWCASED_LIMIT) do
    (enabled.where.not(id: workshop.id).with_future_workshop_events.by_category(workshop.category)
      .or(
        enabled.where.not(id: workshop.id).with_future_workshop_events.by_zone(workshop.zone)
      )
    ).select("workshops.*", "workshop_events.start_time").order("workshop_events.start_time").limit(limit)
  end

  scope :ordered_by_events, -> do
    select(
      <<~SQL
      workshops.*, (
        SELECT MIN(workshop_events.start_time)
        FROM workshop_events
        WHERE workshop_events.start_time > now()
        AND workshop_events.workshop_id = workshops.id
      )
      SQL
    ).order(
      <<~SQL
      (
        SELECT MIN(workshop_events.start_time)
        FROM workshop_events
        WHERE workshop_events.start_time > now()
        AND workshop_events.workshop_id = workshops.id
      ) ASC
      SQL
    )
  end

  def public_visibility
    case self.statut
    when "Validé"
      return true
    when "Soumis"
      return false
    when "Brouillon"
      return false
    end
  end

  def crop_constraints
    return {} unless crop_x && crop_y && crop_width && crop_height
    {
      crop:
        [
          crop_x.to_f,
          crop_y.to_f,
          (crop_width + crop_x).to_f,
          (crop_height + crop_y).to_f
        ]
    }
  end
  
  def colored_statut
    case self.statut
    when "Validé"
      return "<span style='color: #52B07F'>#{self.statut}</span>".html_safe
    when "Soumis"
      return "<span style='color: #FF931E'>#{self.statut}</span>".html_safe
    when "Brouillon"
      return "<span style='color: #808080'>#{self.statut}</span>".html_safe
    end
  end

  def total_booking
    booking_count = 0
    self.workshop_events.each do |event|
     booking_count += event.bookings.count
    end
    return booking_count
  end

  def validated?
    validated_at.present?
  end

  def all_bookings
    bookings = []
    self.workshop_events.each do |event|
       Booking.where(workshop_event_id: event.id, active: true).each do |booking|
        bookings << booking
      end
    end
    return bookings
  end

  def workshop_total_sales
    bookings_to_sum = []
    self.all_bookings.each do |booking|
      bookings_to_sum << booking.total_price_cents
    end
    return "#{(bookings_to_sum.reduce(0, :+))/100}€"
  end

  def prices 
    return self.workshop_prices
  end
  
  def events 
    return self.workshop_events
  end

  def next_event
    self.events.where(start_time < Time.now).order(start_time: :asc).first
  end 

  def duration 
    return self.workshop_duration
  end

  def workshop_duration_presence? 
    if self.workshop_duration.hours.presence != nil && self.workshop_duration.minutes.presence != nil
      return true
    else
      return false
    end
  end

  def total_tickets_solds
   return self.all_bookings.map {|s| s['seats']}.reduce(0, :+)
  end
end
