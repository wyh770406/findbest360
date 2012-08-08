# encoding: utf-8

class BrandType
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  index :order_num
  
  field :name, unique: true
  field :desc
  field :image_url
  field :onsale_at, :type => Date
  field :brandtypelogo
  field :order_num, :type=>Integer,:default=>0
  
  #最高价格
  field :high_price, :type => Float, :precision => 10, :scale => 2, :default=>0
  #最低价格
  field :low_price, :type => Float, :precision => 10, :scale => 2, :default=>0
  #商城数量
  field :merchant_num, :type => Integer, :default => 0
  #总销量
  field :sum_click, :type => Integer, :default => 0
  
  

  belongs_to :brand,index:true

  has_many :products

  mount_uploader :brandtypelogo, BrandtypelogoUploader
  validates_numericality_of :order_num,only_integer:true
  
  
  index :name, unique: true
  index :brand_id
  index :order_num
  index :high_price
  index :low_price
  index :merchant_num
  index :sum_click
end