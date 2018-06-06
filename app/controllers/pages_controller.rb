class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:privacy]

  def home
    @users_podium = User.order(score: :desc).limit(3)
    @up = []
    @up << @users_podium.second
    @up << @users_podium.first
    @up << @users_podium.last
    @users_list = User.order(score: :desc)
    @index_of_user = @users_list.index(current_user)
    if @users_list.length < 10
      @list_to_show = @users_list
    elsif @index_of_user >= 5 && @users_list.length >= 10
      @list_to_show = @users_list[(@index_of_user - 5)..(@index_of_user + 5)]
    else @index_of_user < 5
      @list_to_show = @users_list.first(10)
    end
  end

  def privacy
  end
end
