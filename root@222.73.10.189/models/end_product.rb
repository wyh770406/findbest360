class EndProduct
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :name, unique: true
  field :order_num, :type=>Integer,:default=>0

  belongs_to :middle_product
  has_many :products
end