# encoding: utf-8
class GroupbuyProduct
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  index :price
  index :discount
  index :buyer_num
  index :start_time

  field :price, :type => Float
  field :orig_price, :type => Float
  field :discount, :type => Float
  field :img_url
  field :buyer_num, :type => Integer
  field :title, unique: true
  field :desc
  field :url, unique: true
  field :category_p
  field :category_c
  
  field :shop_name
  field :shop_addr
  field :shop_area
  
  field :start_time, :type => Integer
  field :end_time, :type => Integer
  field :is_tuan800, :type => Boolean, :default => true
  
  belongs_to :groupbuy_city,index: true
  belongs_to :groupbuy_site,index: true
  
  belongs_to :groupbuy_cate,index: true
  belongs_to :groupbuy_subcate,index: true
  
  
  
  
  require 'open-uri'
  
  def self.get_products(site)
    
    if site.present?
      cities = GroupbuyCity.all
      cities.each do |c|
        url = site.link.gsub("#city#", "#{c.pinyin}").gsub("#city_name#", "#{URI::encode(c.name)}")
        doc = Nokogiri::XML(open(url))
        doc.search(site.root).each do |e|
          gp = GroupbuyProduct.new
       
          gp.title = e.search(site.title).try(:text)
          gp.url = e.search(site.url).try(:text)
          gp.img_url = e.search(site.img_url).try(:text)
          gp.desc = e.search(site.desc).try(:text)
          gp.orig_price = e.search(site.orig_price).try(:text)
          gp.price = e.search(site.price).try(:text)
          gp.discount = e.search(site.discount).try(:text)
          gp.buyer_num = e.search(site.buyer_num).try(:text)
          gp.start_time = e.search(site.start_time).try(:text)
          gp.end_time = e.search(site.end_time).try(:text)

          cate = e.search(site.cate).try(:text)
          subcate = site.subcate.present? ? e.search(site.subcate).try(:text) : ""

          if site.f_link.present?
            if gp.url.include?("?")
              gp.url = gp.url + "&" + site.f_link
            else
              gp.url = gp.url + "?" + site.f_link
            end
          end
          
          if site.link == "http://www.meituan.com/api/v2/#city#/deals" && (cate == '零售' || cate == '电商')
            cate = "网上购物" 
          end
          
          gp.groupbuy_city_id = c.id
          gp.groupbuy_site_id = site.id

          if gp.save
            GroupbuySubcate.set_product_cate(gp.id, subcate, cate)
          end
        end
      end
    end
  end

  def self.get_tuan800_products(site)
    if site.present?
      url = site.link
      doc = Nokogiri::XML(open(url))
        
      doc.search("url").each do |e|
        cities =  self.get_city(e.at("city").inner_html.force_encoding("UTF-8"))
        if cities.present?
          cities.each do |c|
            gp = GroupbuyProduct.new(:groupbuy_city_id => c.id)
            gp.title = e.search("title").try(:text).force_encoding("UTF-8")
            gp.url =  e.search("loc").try(:text).force_encoding("UTF-8")
            gp.img_url = e.search("image").try(:text).force_encoding("UTF-8")
            gp.desc = e.search("tip").try(:text).force_encoding("UTF-8")
            value = e.search("value").try(:text).force_encoding("UTF-8")
            gp.orig_price = value
            price = e.search("price").try(:text).force_encoding("UTF-8")
            gp.price = price
            rebate = e.search("rebate").try(:text).force_encoding("UTF-8")
            gp.discount = rebate
            
            if rebate.blank? && value.present? && price.present?
              gp.discount = ((gp.price.to_f/gp.orig_price.to_f)*10).round(1)
            end
            
            gp.buyer_num = e.search("bought").try(:text).force_encoding("UTF-8")
          
            gp.start_time = e.search("starttime").try(:text).force_encoding("UTF-8")
            gp.end_time = e.search("endtime").try(:text).force_encoding("UTF-8")

            cate = e.search("tag").try(:text).force_encoding("UTF-8")
            gp.groupbuy_site_id = site.id
            
            
            gp.save
            
            if site.link == 'http://www.36tuan.com/api/api.php'
              cate = "美容保健"
            end
            if site.link == 'http://www.maidoutuan.com/api800.action?t=nav&v=t800'
              cate = "网上购物"
            end
            
            
            GroupbuySubcate.set_product_cate(gp.id, "", cate)
          end
        end
      end
    end
  end
  
  def self.get_city(name)
    cities = []
    if name == "全国"
      cities = GroupbuyCity.all
    else
      cities = GroupbuyCity.all.select {|x| x.name == name}
    end
    
    return cities
  end

  
  def self.get_groupbuy_products
    sites = GroupbuySite.all
    sites.each do |s|
      begin
        p s.name
        p s.is_tuan800
        if s.is_tuan800
          self.get_tuan800_products(s)
        else
          self.get_products(s)
        end
      rescue Exception => e 
        p e
        next
      end
    end
  end
  
end
