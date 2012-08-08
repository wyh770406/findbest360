# encoding: utf-8
class GroupbuySitesController < ApplicationController
  #caches_page :index
  def index
    
    if params[:city]
      @city = GroupbuyCity.find(params[:city])
    else
      @city = GroupbuyCity.where(:name => CGI::unescape(GroupbuyCity.get_city_by_ip(request.ip))).first 
    end
    
    if @city.blank?
      @city = GroupbuyCity.where({:pinyin => "shanghai"}).first
    end
    
    @sub_cates = GroupbuySubcate.hot_cates

    con = {:groupbuy_city_id => @city.id}
    order_con = {:id => "desc"}
    @category_name = ""
    @sub_cate_name = ""
    @price_sort = "all"
    @sort = '1'
     
    if params[:sub_cate].present?
      @sub_cate = GroupbuySubcate.find(params[:sub_cate])
      @sub_cate_name = @sub_cate.id
      @category = @sub_cate.groupbuy_cate
      @category_name = @category.id
      @sub_cates = @category.groupbuy_subcates
      con.merge!({:groupbuy_subcate_id => @sub_cate.id})
    else
      if params[:category].present?
        @category = GroupbuyCate.find(params[:category])
        @category_name = @category.id
        @sub_cates = @category.groupbuy_subcates
        con.merge!({:groupbuy_cate_id => @category.id})
      else
        @category = GroupbuyCate.first
        @category_name = @category.id
        @sub_cates = @category.groupbuy_subcates
        con.merge!({:groupbuy_cate_id => @category.id})
      end
    end
    
    if params[:price_sort] == "1"
      con.merge!({:price.lt => 10})
      @price_sort = "1"
    end
    
    if params[:price_sort] == "2"
      con.merge!({:price.lt => 50, :price.gt => 10})
      @price_sort = "2"
    end
    
    if params[:price_sort] == "3"
      con.merge!({:price.lt => 100, :price.gt => 50})
      @price_sort = "3"
    end
    
    if params[:price_sort] == "4"
      con.merge!({:price.gt => 100})
      @price_sort = "4"
    end
    
    if params[:sort] == '2'
      order_con = {:discount => "asc"}
      @sort = "2"
    end
    
    if params[:sort] == '3'
      order_con = {:buyer_num => "desc"}
      @sort = "3"
    end
    
    if params[:sort] == '4'
      order_con = {:start_time => "asc"}
      @sort = "4"
    end
    
    @products = GroupbuyProduct.all(:conditions => con).order_by(order_con).page(params[:page]).per(30)
    
    @hot_cities = GroupbuyCity.hot
    @categories = GroupbuyCate.all
  end
  
end

