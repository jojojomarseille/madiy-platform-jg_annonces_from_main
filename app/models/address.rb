class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  
  validates :city, presence: true

  geocoded_by :to_s

  def to_s
    return "" unless address_parts.all?

    "%s, %s %s" % address_parts
  end

  def workshop
    return Workshop.find_by_id(self.addressable_id)
  end

  private

  def address_parts
    [street, postal_code, city]
  end
end
