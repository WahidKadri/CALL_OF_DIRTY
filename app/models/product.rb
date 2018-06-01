class Product < ApplicationRecord
  has_many :packagings, dependent: :destroy
  has_many :bins, through: :packagings
  has_many :scans

  validates :brand, :name, :bar_code, presence: true
  validates :bar_code, uniqueness: true
end

