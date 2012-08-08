# coding: UTF-8
class Adminpanel::BrandsController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index

    @brands = Brand.all.desc("datatype").desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show

    @brand = Brand.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  def new

    @brand = Brand.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit

    @brand = Brand.find(params[:id])
  end

  def create

    @brand = Brand.new(params[:brand])
    @brand.datatype = "OWN"
    respond_to do |format|
      if @brand.save

        format.html { redirect_to(adminpanel_brands_path, :notice => 'Brand 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update

    @brand = Brand.find(params[:id])

    respond_to do |format|
      if @brand.update_attributes(params[:brand])
        format.html { redirect_to(adminpanel_brands_path, :notice => 'Brand 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end

  def assign_top_cate
    @brand = Brand.find(params[:id])

    @assigned = @brand.top_products.sort {|x,y| y <=> x }

    @top_products = TopProduct.all.desc("created_at")

    @unassigned = @top_products - @assigned

  end

  def assign
    @brand = Brand.find(params[:id])
    @top_product= TopProduct.find(params[:top_product_id])

    @brand.top_products << @top_product
    redirect_to(assign_top_cate_adminpanel_brand_path(@brand.id),:notice => "分配成功。")
  end

  def remove
    @brand = Brand.find(params[:id])
    @top_product= TopProduct.find(params[:top_product_id])
    #@top_product.merchants.delete(@merchant)
    #@merchant.top_products.where(id: @top_product.id).destroy_all
    @brand.top_products.delete(@top_product)

    redirect_to(assign_top_cate_adminpanel_brand_path(@brand.id),:notice => "移除成功。")
  end
  def destroy

    @brand = Brand.find(params[:id])
    @brand.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_brands_path,:notice => "删除成功。") }
      format.json
    end
  end

  def search
    @search_key_str = params[:search_key].strip

    @brands = Brand.where(:name => /^(.*?)(#{@search_key_str})/i).desc("created_at").page(params[:page]).per(300)
    respond_to do |format|
      format.html { render(:action=>:index,:notice => "查询成功。") }# index.html.erb
      format.json
    end
  end
end
