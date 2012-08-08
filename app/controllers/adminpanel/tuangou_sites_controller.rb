# coding: UTF-8
class Adminpanel::TuangouSitesController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index
    @tuangou_cate_id = params[:tuangou_cate_id]
    @tuangou_cate = TuangouCate.find(@tuangou_cate_id)
    @tuangou_sites = TuangouSite.where(:tuangou_cate_id => @tuangou_cate_id).desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end





  def show
    @tuangou_cate_id = params[:tuangou_cate_id]
    @tuangou_cate = TuangouCate.find(@tuangou_cate_id)
    @tuangou_site = TuangouSite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end

  end

  def new
    @tuangou_cate_id = params[:tuangou_cate_id]
    @tuangou_cate = TuangouCate.find(@tuangou_cate_id)
    @tuangou_site = TuangouSite.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit
    @tuangou_cate_id = params[:tuangou_cate_id]
    @tuangou_cate = TuangouCate.find(@tuangou_cate_id)
    @tuangou_site = TuangouSite.find(params[:id])
  end

  def create
    @tuangou_cate_id = params[:tuangou_cate_id]
    @tuangou_site = TuangouSite.new(params[:tuangou_site])
    @tuangou_site.tuangou_cate_id=@tuangou_cate_id
    respond_to do |format|
      if @tuangou_site.save

        format.html { redirect_to(adminpanel_tuangou_cate_tuangou_sites_path(@tuangou_cate_id), :notice => 'TuangouSite 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update
    @tuangou_cate_id = params[:tuangou_cate_id]
    @tuangou_site = TuangouSite.find(params[:id])

    respond_to do |format|
      if @tuangou_site.update_attributes(params[:tuangou_site])
        format.html { redirect_to(adminpanel_tuangou_cate_tuangou_sites_path(@tuangou_cate_id), :notice => 'TuangouSite 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end

  def destroy
    @tuangou_cate_id=params[:tuangou_cate_id]
    @tuangou_site = TuangouSite.find(params[:id])
    @tuangou_site.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_tuangou_cate_tuangou_sites_path(@tuangou_cate_id),:notice => "删除成功。") }
      format.json
    end
  end
end
