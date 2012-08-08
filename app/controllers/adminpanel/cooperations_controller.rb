# coding: UTF-8
class Adminpanel::CooperationsController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index

    @cooperations = Cooperation.all.desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show

    @cooperation = Cooperation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  def new

    @cooperation = Cooperation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit

    @cooperation = Cooperation.find(params[:id])
  end

  def create

    @cooperation = Cooperation.new(params[:cooperation])

    respond_to do |format|
      if @cooperation.save

        format.html { redirect_to(adminpanel_cooperations_path, :notice => 'Cooperation 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update

    @cooperation = Cooperation.find(params[:id])

    respond_to do |format|
      if @cooperation.update_attributes(params[:cooperation])
        format.html { redirect_to(adminpanel_cooperations_path, :notice => 'Cooperation 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end


  def destroy

    @cooperation = Cooperation.find(params[:id])
    @cooperation.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_cooperations_path,:notice => "删除成功。") }
      format.json
    end
  end
end
