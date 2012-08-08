# coding: UTF-8
class Adminpanel::ProductsController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"

  
  def index

    if params[:from]=="merchant"
      @merchant_id = params[:merchant_id]
      @merchant = Merchant.find(@merchant_id)

      @products = Product.where(:merchant_id => @merchant_id).desc("created_at").page(params[:page]).per(300)


    elsif params[:from]=="end_product"
      @end_product_id = params[:end_product_id]
      @end_product = EndProduct.find(@end_product_id)
      @middle_product = @end_product.middle_product
      @top_product = @middle_product.top_product
      @products = Product.where(:end_product_id => @end_product_id).page(params[:page]).per(300)
        #.desc("created_at")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show
    if params[:from]=="merchant"
      @merchant_id = params[:merchant_id]
      @merchant = Merchant.find(@merchant_id)
      @top_product = TopProduct.find(params[:top_product_id])
      @middle_product = MiddleProduct.find(params[:middle_product_id])
      @end_product = EndProduct.find(params[:end_product_id])

      @product = Product.find(params[:id])
    elsif params[:from]=="end_product"
      @end_product_id = params[:end_product_id]
      @end_product = EndProduct.find(@end_product_id)

      @product = Product.find(params[:id])
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  def new

    @top_products = TopProduct.all.desc("created_at")

    @middle_products = []

    @end_products = []

    if params[:from]=="merchant"
      @merchant_id = params[:merchant_id]
      @merchant = Merchant.find(@merchant_id)
    elsif params[:from]=="end_product"
      @top_product_id = params[:top_product_id]
      @top_product = TopProduct.find(@top_product_id)
      @middle_product_id = params[:middle_product_id]
      @middle_product = MiddleProduct.find(@middle_product_id)
      @end_product_id = params[:end_product_id]
      @end_product = EndProduct.find(@end_product_id)
    end

    @merchants = Merchant.all.desc("created_at")
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
    
    
    if params[:from]=="merchant"
      @merchant_id = params[:merchant_id]
      @merchant = Merchant.find(@merchant_id)
    elsif params[:from]=="end_product"
      @top_product_id = params[:top_product_id]
      @top_product = TopProduct.find(@top_product_id)
      @middle_product_id = params[:middle_product_id]
      @middle_product = MiddleProduct.find(@middle_product_id)
      @end_product_id = params[:end_product_id]
      @end_product = EndProduct.find(@end_product_id)
    end
    @merchants = Merchant.all.desc("created_at")
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

    if params[:from]=="merchant"

      @merchant_id = params[:merchant_id]

      @product = Product.new(params[:product])
      @product.merchant_id=@merchant_id
    elsif params[:from]=="end_product"
      @top_product_id = params[:top_product_id]
      @top_product = TopProduct.find(@top_product_id)
      @middle_product_id = params[:middle_product_id]
      @middle_product = MiddleProduct.find(@middle_product_id)
      @end_product_id = params[:end_product_id]
      @end_product = EndProduct.find(@end_product_id)

      @product = Product.new(params[:product])
      @product.end_product_id=@end_product_id
    end
    respond_to do |format|
      if @product.save
        if params[:from]=="merchant"
          format.html { redirect_to(adminpanel_merchant_products_path(@merchant_id,:from=>"merchant"), :notice => 'Product 创建成功。') }
          format.json
        else
          format.html { redirect_to(adminpanel_top_product_middle_product_end_product_products_path(@top_product,@middle_product,@end_product,:from=>"end_product"), :notice => 'Product 创建成功。') }
          format.json
        end
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update
    if params[:from]=="merchant"

      @merchant_id = params[:merchant_id]

      @product = Product.find(params[:id])
    elsif params[:from]=="end_product"
      @top_product_id = params[:top_product_id]
      @top_product = TopProduct.find(@top_product_id)
      @middle_product_id = params[:middle_product_id]
      @middle_product = MiddleProduct.find(@middle_product_id)
      @end_product_id = params[:end_product_id]
      @end_product = EndProduct.find(@end_product_id)

      @product = Product.find(params[:id])
      @brand_id = Brand.where(:name=>(params[:product][:brand]).strip).first.id if Brand.where(:name=>(params[:product][:brand]).strip).first
      @brand_type_id = BrandType.where(:name=>(params[:product][:brand_type]).strip).first.id if BrandType.where(:name=>(params[:product][:brand_type]).strip).first
    end
    @product.brand_id = @brand_id

    @product.brand_type_id = @brand_type_id

    respond_to do |format|
      if @product.update_attributes(params[:product])
        if params[:from]=="merchant"
          format.html { redirect_to(adminpanel_merchant_products_path(@merchant_id,:from=>"merchant"), :notice => 'Product 更新成功。') }
          format.json
        else
          format.html { redirect_to(adminpanel_top_product_middle_product_end_product_products_path(@top_product,@middle_product,@end_product,:from=>"end_product"), :notice => 'Product 创建成功。') }
          format.json
        end


      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end

  def destroy
    if params[:from]=="merchant"

      @merchant_id = params[:merchant_id]
    elsif params[:from]=="end_product"
      @top_product_id = params[:top_product_id]
      @top_product = TopProduct.find(@top_product_id)
      @middle_product_id = params[:middle_product_id]
      @middle_product = MiddleProduct.find(@middle_product_id)
      @end_product_id = params[:end_product_id]
      @end_product = EndProduct.find(@end_product_id)
    end

    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      if params[:from]=="merchant"
        format.html { redirect_to(adminpanel_merchant_products_path(@merchant_id,:from=>"merchant"),:notice => "删除成功。") }
        format.json
      elsif params[:from]=="end_product"
        format.html { redirect_to(adminpanel_top_product_middle_product_end_product_products_path(@top_product,@middle_product,@end_product,:from=>"end_product"),:notice => "删除成功。") }
        format.json
      end
    end
  end

  def search
    @search_key_str = params[:search_key].strip
    if params[:from]=="end_product"
      @top_product_id = params[:top_product_id]
      @top_product = TopProduct.find(@top_product_id)
      @middle_product_id = params[:middle_product_id]
      @middle_product = MiddleProduct.find(@middle_product_id)
      
      @end_product_id = params[:end_product_id]
      @end_product = EndProduct.find(@end_product_id)
      @products = Product.where(:title => /^(.*?)(#{@search_key_str})/i).and(:end_product_id => @end_product_id).desc("created_at").page(params[:page]).per(300)
      respond_to do |format|
        format.html { render(:action=>:index,:from=>"end_product",:notice => "查询成功。") }# index.html.erb
        format.json
      end
    elsif params[:from]=="merchant"
      @merchant_id = params[:merchant_id]
      @merchant = Merchant.find(@merchant_id)
      @products = Product.where(:title => /^(.*?)(#{@search_key_str})/i).and(:merchant_id => @merchant_id).desc("created_at").page(params[:page]).per(300)
      respond_to do |format|
        format.html { render(:action=>:index,:from=>"merchant",:notice => "查询成功。") }# index.html.erb
        format.json
      end
    end
  end
end
