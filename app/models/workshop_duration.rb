class WorkshopDuration < ApplicationRecord
  belongs_to :workshop, inverse_of: :workshop_duration

  validates :hours, :minutes, presence: true

  def total
    return nil if [hours, minutes].any?(&:nil?)
    hours.hours + minutes.minutes
  end

 end
