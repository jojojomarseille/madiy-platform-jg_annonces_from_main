class BillingDetail < ApplicationRecord
  attribute :shipping_mode

  belongs_to :user
  accepts_nested_attributes_for :user

  has_one :address, as: :addressable
  accepts_nested_attributes_for :address

  validates :first_name, :last_name, :phone_number, :address, presence: true
  validates :terms, acceptance: true
end
