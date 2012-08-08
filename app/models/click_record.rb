class ClickRecord
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  
  field :ip
  
  belongs_to :product
end
