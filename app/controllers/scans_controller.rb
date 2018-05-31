class ScansController < ApplicationController

  def index
    @scans = Scan.where(user: current_user)
  end

end


