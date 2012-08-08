 # encoding: utf-8

class Product
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  include BaseModel
  #  include Mongoid::Sphinx
  index :price
  index :order_num
  index :click_count
  index(
    [
      [ :kind, Mongo::ASCENDING ],
      [ :title, Mongo::ASCENDING ]
    ],
    unique: true
  )
  scope :from_kind, ->(kind){where(:kind => kind)}


  field :price, :type => Float, :precision => 10, :scale => 2, :default=>0
  field :price_url, :type => String
  field :title, :type => String
  field :stock, :type => Integer
  field :kind, :type  => String
  field :image_url, :type => String
  field :desc
  field :image_info, :type => Array
  field :score, :type => Integer
  field :standard, :type => String
  field :product_code, :type => String
  field :union_url, :type => String, :unique => true
  field :order_num, :type => Integer, :default => 0
  field :click_count, :type => Integer, :default => 0
  field :image_url_exist , :type => Boolean, :default => true

  belongs_to :product_url, index: true
  belongs_to :merchant, index: true
  belongs_to :brand, index: true
  belongs_to :end_product, index: true
  belongs_to :brand_type, index: true

  validates_numericality_of :price,:message=>"请输入数字"
  validates_presence_of :end_product,:message=>"请输入三级类别"
  # validates_url_format_of :product_image_url, :allow_blank => true,:message=>"错误的url格式"
  # validates_url_format_of :product_url, :allow_blank => true,:message=>"错误的url格式"
  validates_numericality_of :order_num,only_integer:true
  embeds_many :comments

  # FullText indexes
  #   search_index(:fields => [:title],
  #                :attributes => [:title],
  #                :options => {} )
  
  redis_search_index(:title_field => :title)

  def self.mmseg_text(text)
    #result = Product.search(text,:max_matches => 1)
    words = []
    algor = RMMSeg::Algorithm.new(text)
    loop do
      tok = algor.next_token
      break if tok.nil?
      words << tok.text
    end
    #    result.raw_result[:words].each do |w|
    #      t = w[0].dup.force_encoding("utf-8")
    #      next if t == "product"
    #      words << ((t == "rubi" and text.downcase.index("ruby")) ? "ruby" : t )
    #    end
    # 修正顺序
    #words = words.sort { |x,y| (text.index(x) || -1) <=> (text.index(y) || -1) }
    Rails.logger.debug { "mmseg:#{words}" }
    words

    #  Rails.logger.debug {"mmseg:#{words.permutation(2).to_a}"}

  end
end
