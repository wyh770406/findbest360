# coding: UTF-8
class Adminpanel::CompositeSitesController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index

    @composite_sites = CompositeSite.all.desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show

    @composite_site = CompositeSite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  def new

    @composite_site = CompositeSite.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit

    @composite_site = CompositeSite.find(params[:id])
  end

  def create

    @composite_site = CompositeSite.new(params[:composite_site])

    respond_to do |format|
      if @composite_site.save

        format.html { redirect_to(adminpanel_composite_sites_path, :notice => 'CompositeSite 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update

    @composite_site = CompositeSite.find(params[:id])

    respond_to do |format|
      if @composite_site.update_attributes(params[:composite_site])
        format.html { redirect_to(adminpanel_composite_sites_path, :notice => 'CompositeSite 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end


  def destroy

    @composite_site = CompositeSite.find(params[:id])
    @composite_site.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_composite_sites_path,:notice => "删除成功。") }
      format.json
    end
  end
end
