class ScansController < ApplicationController

  def index
    @scans = Scan.where(user: current_user).order(created_at: :desc)
  end

end


