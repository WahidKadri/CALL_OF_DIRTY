class Packaging < ApplicationRecord
  belongs_to :bin
  belongs_to :product
end
