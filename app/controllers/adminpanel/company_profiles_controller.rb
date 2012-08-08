# coding: UTF-8
class Adminpanel::CompanyProfilesController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index

    @company_profiles = CompanyProfile.all.desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show

    @company_profile = CompanyProfile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  def new

    @company_profile = CompanyProfile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit

    @company_profile = CompanyProfile.find(params[:id])
  end

  def create

    @company_profile = CompanyProfile.new(params[:company_profile])

    respond_to do |format|
      if @company_profile.save

        format.html { redirect_to(adminpanel_company_profiles_path, :notice => 'CompanyProfile 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update

    @company_profile = CompanyProfile.find(params[:id])

    respond_to do |format|
      if @company_profile.update_attributes(params[:company_profile])
        format.html { redirect_to(adminpanel_company_profiles_path, :notice => 'CompanyProfile 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end


  def destroy

    @company_profile = CompanyProfile.find(params[:id])
    @company_profile.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_company_profiles_path,:notice => "删除成功。") }
      format.json
    end
  end
end
