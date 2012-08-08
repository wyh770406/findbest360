class CooperationsController < ApplicationController
  def index
    @cooperation = Cooperation.all.first
  end

end