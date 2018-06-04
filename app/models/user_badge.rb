class UserBadge < ApplicationRecord
  belongs_to :user
  belongs_to :badge

validates_uniqueness_of :user, scope: [:badge]

end
