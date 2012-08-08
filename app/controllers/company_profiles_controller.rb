class CompanyProfilesController < ApplicationController
  def index
    @company_profile = CompanyProfile.all.first
  end

end
