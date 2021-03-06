# encoding: utf-8
class PromoteDiscountsController < ApplicationController
    layout "zkcx"
  def index
    @top_products = TopProduct.all.asc("order_num")
    if params[:top_product_id]
      @top_product = TopProduct.find(params[:top_product_id])
    else
      @top_product = @top_products.first
    end
    @brands = @top_product.brands.asc("order_num").limit(10)
    @merchants = @top_product.merchants.asc("order_num").limit(10)

    @top_promote_discount = @top_product.promote_discounts.where(:is_top=>true).and(:is_censored=>true).first

    @rest_promote_discounts = @top_product.promote_discounts.where(:is_censored=>true).delete_if{|x| x == @top_promote_discount }
  end

  def new

    @top_products = TopProduct.all.asc("order_num")
    @promote_discount = PromoteDiscount.new
    @merchants = Merchant.all.asc("order_num")
    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end

  def create
    @top_products = TopProduct.all.asc("order_num")
    @merchants = Merchant.all.asc("order_num")
  #  @top_product_id = params[:top_product_id]
    @promote_discount = PromoteDiscount.new(params[:promote_discount])
 #   @promote_discount.top_product_id=@top_product_id
    respond_to do |format|
      if @promote_discount.save
       # flash[:notice] = "折扣促销广告创建成功，你可以继续添加广告。"
        format.html { redirect_to(new_promote_discount_path,:notice => "折扣促销广告创建成功，你可以继续添加广告。") }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end

  def autocomplete_merchant_name
    word = params[:term].strip
    @merchants = Merchant.where({:name => /#{word}/i}).limit(10).order_by("id desc")
    respond_to do |format|
      format.json { render :json => json_for_autocomplete(@words) }
    end
  end

  def json_for_autocomplete(items, extra_data=[])
    items.collect do |item|
      hash = {"id" => item.id.to_s, "label" => item.word, "value" => item.word }
      extra_data.each do |datum|
        hash[datum] = item.send(datum)
      end if extra_data
      hash
    end
  end
end
