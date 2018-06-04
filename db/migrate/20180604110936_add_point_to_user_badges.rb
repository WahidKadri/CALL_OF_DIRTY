class AddPointToUserBadges < ActiveRecord::Migration[5.2]
  def change
    add_column :user_badges, :point, :integer, default: 0, null: false
  end
end
