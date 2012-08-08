class HomeController < ApplicationController
  def index
    @users = User.all
    @top_cates = TopProduct.all.asc("order_num").limit(9)
    @end_cates = TopProduct.all.offset(9).asc("order_num").limit(9)

    @all_cates = @top_cates + @end_cates
  #  @subcates = @top_cates.first.middle_products
  
    if params[:city]
      @city = GroupbuyCity.find(params[:city])
    else
      @city = GroupbuyCity.where(:name => CGI::unescape(GroupbuyCity.get_city_by_ip(request.ip))).first 
    end
    
    @categories = GroupbuyCate.all
    @groupbuy_products = []
    
    GroupbuySite.limit(5).each do |site|
      @groupbuy_products << GroupbuyProduct.where({:groupbuy_city_id => @city.id, :groupbuy_site_id => site.id}).first
    end
    
  end
end
