class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :trackable

  has_one :billing_detail, dependent: :destroy

  has_one :address, as: :addressable
  accepts_nested_attributes_for :address

  has_many :carts, -> { visible }
  has_many :cart_items, through: :carts

  has_many :paid_carts, -> { paid }, class_name: "Cart"
  has_many :vouchers, through: :paid_carts, source: :vouchers
  has_many :bookings, through: :paid_carts

  validates :first_name, :last_name, :birthday, presence: true
end
