# coding: UTF-8
class Adminpanel::MiddleProductsController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)
    @middle_products = MiddleProduct.where(:top_product_id => @top_product_id).desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end


  def filter_middle_product
    @top_product = TopProduct.find(params[:top_product_id])
    @middle_products = @top_product.middle_products

    respond_to do |format|

      format.json { render :json => @middle_products.to_json }
    end
  end


  def show
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)
    @middle_product = MiddleProduct.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json 
    end

  end

  def new
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)
    @middle_product = MiddleProduct.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)
    @middle_product = MiddleProduct.find(params[:id])
  end

  def create
    @top_product_id = params[:top_product_id]
    @middle_product = MiddleProduct.new(params[:middle_product])
    @middle_product.top_product_id=@top_product_id
    respond_to do |format|
      if @middle_product.save

        format.html { redirect_to(adminpanel_top_product_middle_products_path(@top_product_id), :notice => 'MiddleProduct 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update
    @top_product_id = params[:top_product_id]
    @middle_product = MiddleProduct.find(params[:id])

    respond_to do |format|
      if @middle_product.update_attributes(params[:middle_product])
        format.html { redirect_to(adminpanel_top_product_middle_products_path(@top_product_id), :notice => 'MiddleProduct 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end

  def destroy
    @top_product_id=params[:top_product_id]
    @middle_product = MiddleProduct.find(params[:id])
    @middle_product.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_top_product_middle_products_path(@top_product_id),:notice => "删除成功。") }
      format.json
    end
  end
end
