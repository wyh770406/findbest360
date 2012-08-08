class FavoriteSite
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  #extend ValidatesUrlFormatOf

  field :name
  field :url

  belongs_to :user

  #validates_url_format_of :url, :allow_blank => false,:message=>"错误的url格式"
end
