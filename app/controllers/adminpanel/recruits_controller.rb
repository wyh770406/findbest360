# coding: UTF-8
class Adminpanel::RecruitsController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index

    @recruits = Recruit.all.desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show

    @recruit = Recruit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  def new

    @recruit = Recruit.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit

    @recruit = Recruit.find(params[:id])
  end

  def create

    @recruit = Recruit.new(params[:recruit])

    respond_to do |format|
      if @recruit.save

        format.html { redirect_to(adminpanel_recruits_path, :notice => 'Recruit 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update

    @recruit = Recruit.find(params[:id])

    respond_to do |format|
      if @recruit.update_attributes(params[:recruit])
        format.html { redirect_to(adminpanel_recruits_path, :notice => 'Recruit 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end


  def destroy

    @recruit = Recruit.find(params[:id])
    @recruit.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_recruits_path,:notice => "删除成功。") }
      format.json
    end
  end
end
