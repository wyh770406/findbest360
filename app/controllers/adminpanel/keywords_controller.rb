# coding: UTF-8
class Adminpanel::KeywordsController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)
    @keywords = Keyword.where(:top_product_id => @top_product_id).desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end





  def show
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)
    @keyword = Keyword.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end

  end

  def new
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)
    @keyword = Keyword.new
    @merchants = Merchant.all.asc("order_num")
    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)
    @keyword = Keyword.find(params[:id])
    @merchants = Merchant.all.asc("order_num")
  end

  def create
    @top_product_id = params[:top_product_id]
    @keyword = Keyword.new(params[:keyword])
    @keyword.top_product_id=@top_product_id
    respond_to do |format|
      if @keyword.save

        format.html { redirect_to(adminpanel_top_product_keywords_path(@top_product_id), :notice => 'Keyword 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update
    @top_product_id = params[:top_product_id]
    @keyword = Keyword.find(params[:id])

    respond_to do |format|
      if @keyword.update_attributes(params[:keyword])
        format.html { redirect_to(adminpanel_top_product_keywords_path(@top_product_id), :notice => 'Keyword 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end

  def destroy
    @top_product_id=params[:top_product_id]
    @keyword = Keyword.find(params[:id])
    @keyword.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_top_product_keywords_path(@top_product_id),:notice => "删除成功。") }
      format.json
    end
  end
end
