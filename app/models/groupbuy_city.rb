# encoding: utf-8
class GroupbuyCity
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  index :hot
  index :letter
  
  field :pinyin, unique: true
  field :name, unique: true
  field :hot, :type => Boolean, :default => false
  field :url
  field :letter
  
  
  has_many :groupbuy_products
  
  scope :hot, where(hot: true)
  
  require 'open-uri'
  require 'yaml'
  
  
  def self.spider_city
    url = "http://www.lashou.com/changecity"

    doc = Hpricot.parse(open(url).read)

    titles = doc.search("//div[@class='pinyin']//dt")
    cities = doc.search("//div[@class='pinyin']//dd")
    
    titles.each_with_index do |t, index|
      cities[index].search("a").each do |c|
        GroupbuyCity.create({:letter => t.inner_html, :name => c.inner_html, :url => c.attributes["href"]})
      end
    end
  end
  
  def self.hot_cities
    hot_cities = %w{北京 上海 广州 深证 天津 重庆 南京 武汉 西安 杭州 成都 济南 苏州 东莞 郑州 宁波 青岛 大连 沈阳 石家庄 长春 哈尔滨 昆明 长沙 贵阳 桂林}
    
    hot_cities.each do |c|
      g = GroupbuyCity.where(:name => c).first
      g.update_attribute("hot", true) if g.present?
    end
  end
  
  def self.get_meituan_cities(list=false)
    url = "http://www.meituan.com/api/v2/divisions"
    
    doc = ActiveSupport::JSON.decode(open(url).read)
    
    h_a = []
    
    doc["divisions"].each do |e|
      GroupbuyCity.create(:pinyin => e["id"], :name => e["name"]) unless list
      h = {e["name"] => e["pinyin"]}
      h_a << h
    end
    return h_a
  end
  
  def self.get_city_by_ip(ip)
    url = "http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json&ip=#{ip}"
    result = open(url).read
    ip_info = result.present? ? ActiveSupport::JSON.decode(result) : {}
    
    ip_info["city"].present? ? CGI::escape(ip_info["city"]) : CGI::escape('上海')
  rescue Errno::ETIMEDOUT
    return CGI::escape('上海')
  end
    
end
