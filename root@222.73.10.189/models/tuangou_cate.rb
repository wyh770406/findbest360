class TuangouCate
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :name, unique: true


  has_many :tuangou_sites,:dependent=>:destroy

end
