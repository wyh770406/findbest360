class TuangouSite
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :name, unique: true
  field :desc
  field :tuanlogo
  field :tuanurl


  belongs_to :tuangou_cate, index: true


  mount_uploader :tuanlogo, TuanlogoUploader
  #scope :hot, where(hot: true)
end

