# coding: UTF-8
class Adminpanel::ProductsController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"

  
  def index


    @merchant_id = params[:merchant_id]
    @merchant = Merchant.find(@merchant_id)

    @products = Product.where(:merchant_id => @merchant_id).desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show

    @merchant_id = params[:merchant_id]
    @merchant = Merchant.find(@merchant_id)

    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  def new

    @top_products = TopProduct.all.desc("created_at")

    @middle_products = []

    @end_products = []

    @merchant_id = params[:merchant_id]
    @merchant = Merchant.find(@merchant_id)

    @brands = Brand.all.desc("created_at")
    @brand_types = []
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit
    @product = Product.find(params[:id])
    @top_products = TopProduct.all.desc("created_at")
    if @product.end_product.nil?
      @middle_products = MiddleProduct.all.desc("created_at")
    else
      @middle_products =MiddleProduct.where(:top_product_id => @product.end_product.middle_product.top_product.id)
    end
    
    
    
    @merchant_id = params[:merchant_id]
    @merchant = Merchant.find(@merchant_id)


    @brands = Brand.all.desc("created_at")||[]
    if @product.brand.nil?
      @brand_types = BrandType.all.desc("created_at")
    else
      @brand_types = @product.brand.brand_types||[]
    end
    if @product.end_product.nil?
      @end_products = EndProduct.all.desc("created_at")
    else

      @end_products = EndProduct.where(:middle_product_id => @product.end_product.middle_product.id).desc("created_at")
    end


  end

  def create


    @merchant_id = params[:merchant_id]

    @product = Product.new(params[:product])
    @product.merchant_id=@merchant_id
    respond_to do |format|
      if @product.save

        format.html { redirect_to(adminpanel_merchant_products_path(@merchant_id), :notice => 'Product 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update

    @merchant_id = params[:merchant_id]

    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to(adminpanel_merchant_products_path(@merchant_id), :notice => 'Product 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end

  def destroy


    @merchant_id = params[:merchant_id]

    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_merchant_products_path(@merchant_id),:notice => "删除成功。") }
      format.json
    end
  end

  def search
    @search_key_str = params[:search_key].strip
    @merchant_id = params[:merchant_id]
    @merchant = Merchant.find(@merchant_id)
    @products = Product.where(:title => /^(.*?)(#{@search_key_str})/i).and(:merchant_id => @merchant_id).desc("created_at").page(params[:page]).per(300)
    respond_to do |format|
      format.html { render(:action=>:index,:notice => "查询成功。") }# index.html.erb
      format.json
    end
  end
end
