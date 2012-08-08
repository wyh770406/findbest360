# coding: UTF-8
class Adminpanel::EndProductsController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"

  def index
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)

    @middle_product_id = params[:middle_product_id]
    @middle_product = MiddleProduct.find(@middle_product_id)

    @end_products = EndProduct.where(:middle_product_id => @middle_product_id).desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def filter_end_product

    @middle_product = MiddleProduct.find(params[:middle_product_id])
    @end_products = @middle_product.end_products

    puts @end_products.to_json
    respond_to do |format|

      format.json { render :json => @end_products.to_json }
    end
  end


  def show
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)

    @middle_product_id = params[:middle_product_id]
    @middle_product = MiddleProduct.find(@middle_product_id)

    @end_product = EndProduct.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  def new
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)

    @middle_product_id = params[:middle_product_id]
    @middle_product = MiddleProduct.find(@middle_product_id)

    @end_product = EndProduct.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)

    @middle_product_id = params[:middle_product_id]
    @middle_product = MiddleProduct.find(@middle_product_id)

    @end_product = EndProduct.find(params[:id])
  end

  def create
    @top_product_id = params[:top_product_id]
    
    @middle_product_id = params[:middle_product_id]

    @end_product = EndProduct.new(params[:end_product])
    @end_product.middle_product_id=@middle_product_id
    respond_to do |format|
      if @end_product.save

        format.html { redirect_to(adminpanel_top_product_middle_product_end_products_path(@top_product_id,@middle_product_id), :notice => 'EndProduct 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)
    @middle_product_id = params[:middle_product_id]
    @middle_product = MiddleProduct.find(@middle_product_id)
    @end_product = EndProduct.find(params[:id])

    respond_to do |format|
      if @end_product.update_attributes(params[:end_product])
        format.html { redirect_to(adminpanel_top_product_middle_product_end_products_path(@top_product_id,@middle_product_id), :notice => 'EndProduct 更新成功。') }
        format.json
      else

        format.html { render :action => "edit" }
        format.json
      end
    end
  end

  def destroy
    puts "dddddddddd"
    puts "----------------------------------------------"
    @top_product_id=params[:top_product_id]

    @middle_product_id = params[:middle_product_id]

    @end_product = EndProduct.find(params[:id])
    @end_product.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_top_product_middle_product_end_products_path(@top_product_id,@middle_product_id),:notice => "删除成功。") }
      format.json
    end
  end
end
