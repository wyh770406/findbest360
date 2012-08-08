# coding: UTF-8
class Adminpanel::TuangouCatesController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index
    @tuangou_cates = TuangouCate.all.desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show
    @tuangou_cate = TuangouCate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  def new
    @tuangou_cate = TuangouCate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit
    @tuangou_cate = TuangouCate.find(params[:id])
  end

  def create
    @tuangou_cate = TuangouCate.new(params[:tuangou_cate])

    respond_to do |format|
      if @tuangou_cate.save

        format.html { redirect_to(adminpanel_tuangou_cates_path, :notice => 'TuangouCate 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update
    @tuangou_cate = TuangouCate.find(params[:id])

    respond_to do |format|
      if @tuangou_cate.update_attributes(params[:tuangou_cate])
        format.html { redirect_to(adminpanel_tuangou_cates_path, :notice => 'TuangouCate 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end

  def destroy
    @tuangou_cate = TuangouCate.find(params[:id])
    @tuangou_cate.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_tuangou_cates_path,:notice => "删除成功。") }
      format.json
    end
  end
end
