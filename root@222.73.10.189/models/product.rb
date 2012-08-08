# encoding: utf-8

class Product
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  include BaseModel
  #  include Mongoid::Sphinx


  scope :from_kind, ->(kind){where(:kind => kind)}


  field :price, :type => BigDecimal, :precision => 10, :scale => 2
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

  belongs_to :product_url
  belongs_to :merchant
  belongs_to :brand
  belongs_to :end_product
  belongs_to :brand_type

  validates_numericality_of :price,:message=>"请输入数字"
  validates_presence_of :end_product,:message=>"请输入三级类别"
  # validates_url_format_of :product_image_url, :allow_blank => true,:message=>"错误的url格式"
  # validates_url_format_of :product_url, :allow_blank => true,:message=>"错误的url格式"
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
