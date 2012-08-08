class WebsiteGuide
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  #extend ValidatesUrlFormatOf

  field :name
  field :url

  belongs_to :user
end
