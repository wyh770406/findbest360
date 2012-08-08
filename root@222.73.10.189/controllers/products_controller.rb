class ProductsController < ApplicationController
  def index

  end

  def search
 #   @products = Product.all
    #@products = Product.search(params[:search_key].strip)
    result = Search.query(params[:search_key].strip,:limit=>10000)
    ids = []
    result.each do |prod|
      ids << BSON::ObjectId(prod["id"])
    end
    
    @products = Product.includes([:end_product]).any_in(:_id =>ids).asc("order_num").asc("price").page(params[:page]).per(40)

    @products.sort! {|x,y| x.end_product.order_num <=> y.end_product.order_num }



  end

  def detail
    puts "dddd4445556667777"
  end


end
