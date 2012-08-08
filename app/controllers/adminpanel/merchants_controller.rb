# coding: UTF-8
class Adminpanel::MerchantsController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index

    @merchants = Merchant.all.desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show

    @merchant = Merchant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  def new

    @merchant = Merchant.new
    @top_products = TopProduct.all.desc("created_at")
    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit

    @merchant = Merchant.find(params[:id])
    @top_products = TopProduct.all.desc("created_at")
  end

  def create

    @merchant = Merchant.new(params[:merchant])

    respond_to do |format|
      if @merchant.save
        format.html { redirect_to(adminpanel_merchants_path, :notice => 'Merchant 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end

  end

  def update

    @merchant = Merchant.find(params[:id])

    respond_to do |format|
      if @merchant.update_attributes(params[:merchant])

        format.html { redirect_to(adminpanel_merchants_path(), :notice => 'Merchant 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end

  def assign_top_cate
    @merchant = Merchant.find(params[:id])

    @assigned = @merchant.top_products.sort {|x,y| y <=> x }

    @top_products = TopProduct.all.desc("created_at")

    @unassigned = @top_products - @assigned

  end

  def assign
    @merchant = Merchant.find(params[:id])
    @top_product= TopProduct.find(params[:top_product_id])

    @merchant.top_products << @top_product
    redirect_to(assign_top_cate_adminpanel_merchant_path(@merchant.id),:notice => "分配成功。")
  end

  def remove
    @merchant = Merchant.find(params[:id])
    @top_product= TopProduct.find(params[:top_product_id])
    #@top_product.merchants.delete(@merchant)
    #@merchant.top_products.where(id: @top_product.id).destroy_all
    @merchant.top_products.delete(@top_product)

    redirect_to(assign_top_cate_adminpanel_merchant_path(@merchant.id),:notice => "移除成功。")
  end

  def destroy

    @merchant = Merchant.find(params[:id])

    @merchant.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_merchants_path,:notice => "删除成功。") }
      format.json
    end
  end

  def search
    @search_key_str = params[:search_key].strip

    @merchants = Merchant.where(:name => /^(.*?)(#{@search_key_str})/i).desc("created_at").page(params[:page]).per(300)
    respond_to do |format|
      format.html { render(:action=>:index,:notice => "查询成功。") }# index.html.erb
      format.json
    end
  end
end
