# encoding: utf-8

class Brand
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  extend ValidatesUrlFormatOf

  field :name, unique: true
  field :brandlogo

  field :desc
  field :service
  field :order_num, :type=>Integer,:default=>0


  field :brandurl
  field :taobrandurl
  has_and_belongs_to_many :top_products

  has_many :products

  mount_uploader :brandlogo, BrandlogoUploader

  has_many :brand_types
  #validates_url_format_of :brandurl, :allow_blank => true,:message=>"错误的url格式"
end