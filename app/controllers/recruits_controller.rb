class RecruitsController < ApplicationController
  def index
    @recruit = Recruit.all.first
  end

end