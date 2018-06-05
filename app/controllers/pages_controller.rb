class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:privacy]

  def home
    @users_podium = User.order(score: :desc).limit(3)
    @user_first = @users_podium.first
    @user_second = @users_podium.second
    @user_last = @users_podium.last

    @users_list = User.order(score: :desc)
    @index_of_user = @users_list.index(current_user)
    @list_to_show = @users_list[(@index_of_user - 5).. (@index_of_user + 5) ]
  end

  def privacy
  end
end
