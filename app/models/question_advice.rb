# encoding: utf-8
class QuestionAdvice
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :title
  field :desc
  validates_presence_of :title,:message=>"请输入标题"
  validates_presence_of :desc,:message=>"请输入内容"
end