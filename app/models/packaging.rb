class Packaging < ApplicationRecord
  belongs_to :bin
  belongs_to :product

  validates :name, presence: true
end
