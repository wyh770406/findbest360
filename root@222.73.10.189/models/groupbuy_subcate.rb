# encoding: utf-8
class GroupbuySubcate
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  
  field :name, unique: true
  field :desc
  field :hot ,:type => Boolean, :default => false
  belongs_to :groupbuy_cate
  has_many :groupbuy_products
  
  scope :hot_cates, where(:hot => true)
  
  def self.set_hot_cates
    sub_cates = %w{自助 烧烤 料理 西餐 海鲜 甜点 摄影 KTV 台球桌游 游乐场 酒吧 美容美体 美发 SPA 按摩足疗 养生健身 口腔护理 旅游 酒店 汽车保养}
    sub_cates.each do |cate|
      GroupbuySubcate.where(:name => cate).first.update_attribute("hot", true)
    end
  end
  
  
  def self.set_product_cate(gp_id, subcate, cate)
    gp = GroupbuyProduct.find gp_id
    sub_c, c  = self.get_same_cate(cate, subcate)
    
    gp.groupbuy_cate_id = c.id
    gp.groupbuy_subcate_id = sub_c.id
    gp.save
  end
  
  #判断从团购页面抓取来的 分类跟现在分类是否相同，如果相同返回，如果不相同创建新分类
  def self.get_same_cate(cate, subcate)
    
    ca = self.get_parent_cate(cate)
    sa = self.get_child_cate(ca, subcate)

    return sa,ca
  end
  
  #判断两个分类是否相同，规则：如果分类中两个字相同，表示两个分类相同
  def self.same_char(s1, s2)
    
    s2.force_encoding("UTF-8")

    i = 0
    
    s1.each_char do |s|
      s2.each_char do |c|
        if s == c
          i += 1
        end
      end
    end
    
    i
  end
  
  def self.get_parent_cate(cate)
    if cate.blank?
      return GroupbuyCate.where(:name => "其他").first
    end
    
    cates = GroupbuyCate.all
    
    arr = {}
    cates.each do |c|
      num = self.same_char(c.name, cate)
      if num >= 2 
        arr.merge!({c.id => num})
      end
    end
    
    if arr.blank?
      return GroupbuyCate.where(:name => "其他").first
    else
      sid = arr.sort {|x,y| y[1] <=> x[1]}.first.first
      return GroupbuyCate.find sid
    end
  end
  
  
  def self.get_child_cate(ca, subcate)
    subcates = ca.groupbuy_subcates
    
    if subcate.blank?
      return subcates.select {|x| x.name == '其他'}.first
    end
    
    arr = {}
    
    subcates.each do |s|
      num = self.same_char(s.name, subcate)
      if num >= 2 
        arr.merge!({s.id => num})
      end
    end
    
    if arr.blank?
      return GroupbuySubcate.create(:name => subcate, :groupbuy_cate_id => ca.id )
    else
      sid = arr.sort {|x,y| y[1] <=> x[1]}.first.first
      return GroupbuySubcate.find sid
    end
  end
  
  
end
