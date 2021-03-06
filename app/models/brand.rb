# encoding: utf-8

class Brand
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  extend ValidatesUrlFormatOf
  index :order_num
  
  field :name, unique: true
  field :brandlogo

  field :desc
  field :service
  field :order_num, :type=>Integer,:default=>0
  field :datatype,:default=>"OWN"

  field :brandurl
  field :taobrandurl
  has_and_belongs_to_many :top_products, index: true

  has_many :products,:dependent=>:destroy

  mount_uploader :brandlogo, BrandlogoUploader

  has_many :brand_types
  #validates_url_format_of :brandurl, :allow_blank => true,:message=>"错误的url格式"
  has_many :brand_comments

  validates_numericality_of :order_num,only_integer:true
end