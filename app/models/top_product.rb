class TopProduct
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  index :order_num

  field :name, unique: true
  field :topicon
  field :order_num, :type=>Integer,:default=>0
  #paginates_per 20
  #field :merchant_ids,  :type=> Array, :default=> []

  mount_uploader :topicon, TopiconUploader

  has_many :middle_products,:dependent=>:destroy
  has_many :promote_discounts
  has_many :keywords
  has_and_belongs_to_many :merchants #, :stored_as => :array, :inverse_of => :merchants, :class_name => 'Merchant',:foreign_key => 'merchant_ids'
  has_and_belongs_to_many :brands#, :stored_as => :array, :inverse_of => :brands,:foreign_key => 'brand_ids'
  validates_numericality_of :order_num,only_integer:true
end
