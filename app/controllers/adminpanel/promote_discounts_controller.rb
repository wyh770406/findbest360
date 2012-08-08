# coding: UTF-8
class Adminpanel::PromoteDiscountsController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  def index
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)
    @promote_discounts = PromoteDiscount.where(:top_product_id => @top_product_id).desc("created_at").page(params[:page]).per(300)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end


  def filter_promote_discount
    @top_product = TopProduct.find(params[:top_product_id])
    @promote_discounts = @top_product.promote_discounts

    respond_to do |format|

      format.json { render :json => @promote_discounts.to_json }
    end
  end


  def show
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)
    @promote_discount = PromoteDiscount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end

  end

  def new
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)
    @promote_discount = PromoteDiscount.new
    @merchants = Merchant.all.asc("order_num")
    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def edit
    @top_product_id = params[:top_product_id]
    @top_product = TopProduct.find(@top_product_id)
    @promote_discount = PromoteDiscount.find(params[:id])
    @merchants = Merchant.all.asc("order_num")
  end

  def create
    @top_product_id = params[:top_product_id]
    @promote_discount = PromoteDiscount.new(params[:promote_discount])
    @promote_discount.top_product_id=@top_product_id
    respond_to do |format|
      if @promote_discount.save

        format.html { redirect_to(adminpanel_top_product_promote_discounts_path(@top_product_id), :notice => 'PromoteDiscount 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def update
    @top_product_id = params[:top_product_id]
    @promote_discount = PromoteDiscount.find(params[:id])

    respond_to do |format|
      if @promote_discount.update_attributes(params[:promote_discount])
        format.html { redirect_to(adminpanel_top_product_promote_discounts_path(@top_product_id), :notice => 'PromoteDiscount 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end

  def destroy
    @top_product_id=params[:top_product_id]
    @promote_discount = PromoteDiscount.find(params[:id])
    @promote_discount.destroy

    respond_to do |format|
      format.html { redirect_to(adminpanel_top_product_promote_discounts_path(@top_product_id),:notice => "删除成功。") }
      format.json
    end
  end
end
