# coding: UTF-8
class Adminpanel::BrandTypesController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index
    @brand_id = params[:brand_id]
    @brand = Brand.find(@brand_id)
    @brand_types = BrandType.where(:brand_id => @brand_id).desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def filter_brand_type
    @brand = Brand.find(params[:brand_id])

    @brand_types = @brand.brand_types

    respond_to do |format|

      format.json { render :json => @brand_types.to_json }
    end
  end

  def show
    @brand_id = params[:brand_id]
    @brand = Brand.find(@brand_id)
    @brand_type = BrandType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  def new
    @brand_id = params[:brand_id]
    @brand = Brand.find(@brand_id)
    @brand_type = BrandType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit
    @brand_id = params[:brand_id]
    @brand = Brand.find(@brand_id)
    @brand_type = BrandType.find(params[:id])
  end

  def create
    @brand_id = params[:brand_id]
    @brand = Brand.find(@brand_id)
    @brand_type = BrandType.new(params[:brand_type])
    @brand_type.brand_id = @brand_id
    @brand_type.onsale_at=Date.new(params[:brand_type]["onsale_at(1i)"].to_i,params[:brand_type]["onsale_at(2i)"].to_i,params[:brand_type]["onsale_at(3i)"].to_i)
    respond_to do |format|
      if @brand_type.save

        format.html { redirect_to(adminpanel_brand_brand_types_path(@brand), :notice => 'BrandType 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update
    @brand_id = params[:brand_id]
    @brand = Brand.find(@brand_id)
    @brand_type = BrandType.find(params[:id])
    @brand_type.onsale_at=Date.new(params[:brand_type]["onsale_at(1i)"].to_i,params[:brand_type]["onsale_at(2i)"].to_i,params[:brand_type]["onsale_at(3i)"].to_i)

    respond_to do |format|
      if @brand_type.update_attributes(params[:brand_type])
        format.html { redirect_to(adminpanel_brand_brand_types_path(@brand), :notice => 'BrandType更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end

 
  def destroy
    @brand_id = params[:brand_id]
    @brand = Brand.find(@brand_id)

    @brand_type = BrandType.find(params[:id])
    @brand_type.products.all.each do |product|
      product.update_attributes(:brand_type_id=>nil)
    end
    @brand_type.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_brand_brand_types_path(@brand),:notice => "删除成功。") }
      format.json
    end
  end

  def search
    @search_key_str = params[:search_key].strip
    @brand_id = params[:brand_id]
    @brand = Brand.find(@brand_id)

    @brand_types = BrandType.where(:name => /^(.*?)(#{@search_key_str})/i).desc("created_at").page(params[:page]).per(300)
    respond_to do |format|
      format.html { render(:action=>:index,:notice => "查询成功。") }# index.html.erb :brand_id => @brand_id).and(
      format.json
    end
  end
end
