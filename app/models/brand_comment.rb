# encoding: utf-8
class BrandComment
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  
  field :title, :type => String
  field :content, :type => String
  field :author_name, :type => String
  field :star, :type => Integer
  field :publish_at, :type => Time
  field :ip
  
  belongs_to :user
  belongs_to :brand

  validates_presence_of :content, :message => "评论内容不能为空"
  
  
end
