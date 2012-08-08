class AdminController < ApplicationController
  before_filter :authenticate_admin!

  layout "admin"
  def index
    @resource = User.where("name = 'admin'").first
  end




end
