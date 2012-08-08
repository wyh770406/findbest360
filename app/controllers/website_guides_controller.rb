class WebsiteGuidesController < ApplicationController
  before_filter :authenticate_user!,:except=>:index
  caches_page :index
  def index
    if user_signed_in?
      @most_used_websites = WebsiteGuide.where(:user_id => current_user.id).asc("created_at").limit(12)
    end
    @composite_sites = CompositeSite.all.asc("order_num")
    @top_cates = TopProduct.all.asc("order_num")
    #@brands = Brand.all.asc("created_at").limit(50)
    @tuan_cates = TuangouCate.all.asc("created_at")
  end

  def most_used_website

    @website_guides = WebsiteGuide.where(:user_id => current_user.id).asc("created_at")
    expire_page :action => :index
    #expire_page :action => "show", :id => params[:list][:id]
    respond_to do |format|
      format.js do
        #        render :partial=>"most_used_website"
        #        render :update do |page|
        #          page.alert("success")
        #        end
      end
    end

  end

  def save_favorite_site

    params[:title_link].each do |title_link|
      if title_link[1][:link_id].strip==""
        WebsiteGuide.create(:name=>title_link[1][:title],:url=>title_link[1][:link],:user=>current_user)
      else
        @website_guide = WebsiteGuide.find(title_link[1][:link_id])
        @website_guide.update_attributes(:name=>title_link[1][:title],:url=>title_link[1][:link])
      end
    end
  end

  def destroy
    @website_guide=WebsiteGuide.find(params[:id])
    @ord_id=params[:ord_id]
    @website_guide.destroy
  end
end
