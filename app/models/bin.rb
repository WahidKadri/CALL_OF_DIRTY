class Bin < ApplicationRecord
  has_many :packagings
  has_many :products, through: :packagings

  validates :color, presence: true
  validates :color, inclusion: { in: %w(jaune blanc vert) }
end
