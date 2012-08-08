class ProductsController < ApplicationController
  autocomplete :keyword, :word, :display_value => :word

  def index

  end

  def search
    #   @products = Product.all
    if params[:search_key].nil?
      redirect_to "/"
      return
    end

    @search_key = params[:search_key].strip

    if params[:count_flag]=="count"
      keyword = Keyword.where(:word=>@search_key).first

      new_order_num = keyword.order_num + 1

      keyword.update_attributes(:order_num=>new_order_num)
    end
    #@products = Product.search(params[:search_key].strip)
    result = Search.query(params[:search_key].strip,:limit=>10000)
    ids = []
    result.each do |prod|
      ids << BSON::ObjectId(prod["id"])
    end


    con = {:price.ne=>nil}
    order_con = [[:order_num, :asc],[:price, :asc]]

    if params[:start_price].present?
      con.merge!({:price.gte => params[:start_price].to_f})
    end

    if params[:end_price].present?
      con.merge!({:price.lte => params[:end_price].to_f})
    end

    if params[:brand].present?
      con.merge!({:brand_id => params[:brand]})
    end

    if params[:e_p].present?
      con.merge!({:end_product_id => params[:e_p]})
    end

    if params[:merchant].present?
      con.merge!({:merchant_id => params[:merchant]})
    end

    if params[:price_sort].present? && params[:price_sort] == 'up'
      order_con = [[:order_num, :asc],[:price, :asc]]
    end

    if params[:price_sort].present? && params[:price_sort] == 'down'
      order_con = [[:order_num, :asc],[:price, :desc]]
    end

    if params[:price_sort].present? && params[:price_sort] == 'c_down'
      order_con = [[:order_num, :asc],[:click_count, :desc]]
    end

    if params[:price_sort].present? && params[:price_sort] == 'c_up'
      order_con = [[:order_num, :asc],[:click_count, :asc]]
    end

  #  @products = Product.includes(:end_products,:brands,:brand_types,:merchants).any_in(:_id =>ids).where(con).order_by(order_con).page(params[:page]).per(40)
    #  @products = sort_product(@products)
    #@products.sort! {|x,y| x.end_product.order_num <=> y.end_product.order_num }
    merchant_sort_ids = Product.includes(:end_products,:brands,:brand_types,:merchants).any_in(:_id =>ids).where(con).distinct(:merchant_id)
    end_product_sort_ids = Product.includes(:end_products,:brands,:brand_types,:merchants).any_in(:_id =>ids).where(con).distinct(:end_product_id)
    brand_sort_ids = Product.includes(:end_products,:brands,:brand_types,:merchants).any_in(:_id =>ids).where(con).distinct(:brand_id)
    #Rails.logger.debug { "merchant_sort_products:#{@merchant_sort_products}" }
    brand_type_sort_ids = Product.includes(:end_products,:brands,:brand_types,:merchants).any_in(:_id =>ids).where(con).distinct(:brand_type_id)
    # @products = @products.page(params[:page]).per(40)
    @end_products = sort_end_product(end_product_sort_ids)
    @brands = sort_brand(brand_sort_ids)
    @brand_types = sort_brand_type(brand_type_sort_ids)
    @merchants = sort_merchant(merchant_sort_ids)

#    all_brand_type_products = []
#    @brand_types.each do |brand_type|
#      brand_type_products = brand_type.products.where(:price.ne=>nil)
#      brand_type_products.each do |brand_type_product|
#        all_brand_type_products << brand_type_product
#
#      end
#
#    end
    @products = Product.includes(:end_products,:brands,:brand_types,:merchants).any_in(:_id =>ids).where(con.merge!({:brand_type_id => nil})).order_by(order_con).page(params[:page]).per(40)
      #@products - all_brand_type_products

  end

  def detail
    @brand_type = BrandType.includes(:brands).find(params[:brand_type])

    @brand = @brand_type.brand


   # @jingdong_product = @brand_type.products.asc("created_at").first


    @brand_type_products = @brand_type.products.where(:price.ne=>nil).asc("price")
    @end_product = @brand_type_products.first.end_product
    #@total_merchant = (@brand_type.products.where(:price.ne=>nil).distinct(:merchant_id)).count
#    total_merchant_ids = []
#    @brand_type_products.each do |brand_type_product|
#      total_merchant_ids<<brand_type_product.merchant_id
#    end
#    @total_merchant=(total_merchant_ids.compact.uniq!).size
  end

  def sort_brand_type(ids)
    BrandType.any_in(:_id =>ids).asc("order_num").limit(120)
  end

  def sort_end_product(ids)
    middle_product_ids = EndProduct.any_in(:_id =>ids).asc("order_num").distinct(:middle_product_id)
    middle_products = MiddleProduct.any_in(:_id =>middle_product_ids).asc("order_num")
    end_products = middle_products.map do |middle_product|
      {
        :middle_product => middle_product,
        :end_product=>EndProduct.any_in(:_id =>ids).where(:middle_product_id=>middle_product.id).asc("order_num")
      }
    end
    end_products
  end
  #  def sort_end_product(products)
  #
  #    arr_end_products = products.map do |product|
  #      if product.end_product
  #        {
  #          :order_num => product.end_product.order_num,
  #          :end_product=>product.end_product
  #        }
  #      end
  #    end
  #
  #    arr_end_products = arr_end_products.uniq.compact
  #
  #    arr_end_products.sort! {|x,y| x[:order_num] <=> y[:order_num] }
  #
  #    final_end_products = []
  #
  #    arr_end_products.each do |order_num_end_product|
  #      final_end_products << order_num_end_product[:end_product]
  #    end
  #
  #    final_end_products[0,20]
  #  end

  def sort_brand(ids)
    Brand.any_in(:_id =>ids).asc("order_num")
  end
  #  def sort_brand(products)
  #    arr_brands = products.map do |product|
  #      if product.brand
  #        {
  #          :order_num => product.brand.order_num,
  #          :brand=>product.brand
  #        }
  #      end
  #    end
  #
  #    arr_brands = arr_brands.uniq.compact
  #
  #    arr_brands.sort! {|x,y| x[:order_num] <=> y[:order_num] }
  #
  #    final_brands = []
  #
  #    arr_brands.each do |order_num_brand|
  #      if order_num_brand
  #        final_brands << order_num_brand[:brand]
  #      end
  #    end
  #
  #    final_brands[0,20]
  #  end

  #  def sort_merchant(products)
  #    arr_merchants = products.map do |product|
  #      {
  #        :order_num => product.merchant.order_num,
  #        :merchant=>product.merchant
  #      }
  #    end
  #
  #    arr_merchants = arr_merchants.uniq
  #
  #    arr_merchants.sort! {|x,y| x[:order_num] <=> y[:order_num] }
  #
  #    final_merchants = []
  #
  #    arr_merchants.each do |order_num_merchant|
  #      final_merchants << order_num_merchant[:merchant]
  #    end
  #
  #    final_merchants[0,20]
  #
  #  end

  def sort_merchant(ids)
    Merchant.any_in(:_id =>ids).asc("order_num")
  end

  def sort_product(products)
    arr_products = products.map do |product|
      {
        :order_num => product.end_product.order_num,
        :product=>product
      }
    end
    arr_products.sort! {|x,y| x[:order_num] <=> y[:order_num] }

    final_products = []

    arr_products.each do |order_num_product|
      final_products << order_num_product[:product]
    end

    final_products
  end

  def record
    @product = Product.find params[:id]
    @record = ClickRecord.where({:ip => request.ip, :product_id => @product.id})

    if @record.blank?
      ClickRecord.create({:ip => request.ip, :product_id => @product.id})
      @product.update_attribute(:click_count, @product.click_count + 1)
    end

    #    redirect_to @product.union_url
  end

  def autocomplete_keyword_word
    word = Pinyin.t(params[:term], '')
    @words = Keyword.where({:pinyin => /#{word}/i}).limit(10).order_by("id desc")
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

