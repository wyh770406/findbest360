# coding: UTF-8
class Adminpanel::TopProductsController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index
    @top_products = TopProduct.all.desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show
    @top_product = TopProduct.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  def new
    @top_product = TopProduct.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit
    @top_product = TopProduct.find(params[:id])
  end

  def create
    @top_product = TopProduct.new(params[:top_product])

    respond_to do |format|
      if @top_product.save

        format.html { redirect_to(adminpanel_top_products_path, :notice => 'TopProduct 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update
    @top_product = TopProduct.find(params[:id])

    respond_to do |format|
      if @top_product.update_attributes(params[:top_product])
        format.html { redirect_to(adminpanel_top_products_path, :notice => 'TopProduct 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end

  def destroy
    @top_product = TopProduct.find(params[:id])
    @top_product.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_top_products_path,:notice => "删除成功。") }
      format.json
    end
  end
end
