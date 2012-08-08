# encoding: utf-8
class PromoteDiscount
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :title, :type => String
  field :link_to_url, :type  => String
  field :pdimageurl
  field :desc
  field :is_top, :type => Boolean, :default => false
  field :is_home, :type => Boolean, :default => false
  field :is_censored, :type => Boolean, :default => false
  
  belongs_to :merchant,index:true
  belongs_to :top_product,index:true

  validates_presence_of :top_product,:message=>"请选择分类"
  validates_presence_of :merchant,:message=>"请选择商家"
  mount_uploader :pdimageurl, PdimageurlUploader
end
