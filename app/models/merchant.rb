# encoding: utf-8

class Merchant
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  extend ValidatesUrlFormatOf
  index :order_num

  field :name, unique: true
  field :merchantlogo

  field :desc
  field :service
  field :order_num, :type=>Integer,:default=>0

  field :merchanturl
  field :is_known, :type => Boolean, :default => false
  
  has_many :products,:dependent=>:destroy
  has_many :promote_discounts
  mount_uploader :merchantlogo, MerchantlogoUploader

  has_and_belongs_to_many :top_products, index: true  #, :stored_as => :array, :inverse_of => :top_products, :class_name => 'TopProduct',:foreign_key => 'top_product_ids'

  validates_numericality_of :order_num,only_integer:true

  # validates_url_format_of :merchanturl, :allow_blank => true,:message=>"错误的url格式"
end