class MiddleProduct
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  index :top_product_id
  index :order_num
  
  field :name, unique: true
  field :order_num, :type=>Integer,:default=>0
  belongs_to :top_product
  has_many :end_products,:dependent=>:destroy
  
  validates_numericality_of :order_num,only_integer:true
  #scope :hot, where(hot: true)
end

