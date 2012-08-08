class CompositeSite
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  #extend ValidatesUrlFormatOf

  field :name, unique: true
  field :desc
  field :compositelogo
  field :compositeurl
  field :order_num, :type=>Integer,:default=>0
  field :service

  mount_uploader :compositelogo, CompositelogoUploader

  #validates_url_format_of :url, :allow_blank => false,:message=>"错误的url格式"
end
