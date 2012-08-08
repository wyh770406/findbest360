# encoding: utf-8

class Comment
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :title, :type => String
  field :content, :type => String
  field :author_name, :type => String
  field :star, :type => Integer
  field :publish_at, :type => Time

  embedded_in :product

end