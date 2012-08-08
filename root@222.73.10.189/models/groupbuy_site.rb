# encoding: utf-8
class GroupbuySite
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  
  field :name, unique: true
  field :link
  
  field :root
  field :city
  field :price
  field :orig_price
  field :discount
  field :img_url
  field :buyer_num
  field :title
  field :desc
  field :url
  field :category_p
  field :category_c
  
  field :shop_name
  field :shop_addr
  field :shop_area
  
  field :f_link
  
  field :start_time
  field :end_time
  
  has_many :groupbuy_products


  def self.create_sites
    infos = YAML.load(File.open(File.join(Rails.root, 'config', 'tuaninfo.yml'), 'r:utf-8'))
    infos["links"].each do |key, value|
      gp = GroupbuySite.new(value)
      if gp.valid?
        gp.save!
      end
    end
  end
  
end

