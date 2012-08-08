# encoding: utf-8

class Keyword
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  index :order_num
  index :word
  index :pinyin
  
  field :word, unique: true
  field :order_num, :type=>Integer,:default=>0
  field :pinyin
  field :hot, :type => Boolean, :default => false
  belongs_to :top_product,index:true

  validates_numericality_of :order_num,only_integer:true
end
