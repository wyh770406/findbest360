# encoding: utf-8
class GroupbuyCate
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  
  field :name, unique: true
  field :desc
  
  has_many :groupbuy_subcates
  has_many :groupbuy_products
  
  
  
  
  
  
  
  def self.create_categories_from_yaml
    categories = YAML.load(File.open(File.join(Rails.root, 'config', 'category.yml'), 'r:utf-8')) rescue nil
    if categories.present?
      categories["categories"].each do |c|
        gc = GroupbuyCate.create(:name => c.first)
        c.last.each do |s|
          GroupbuySubcate.create(:name => s, :groupbuy_cate_id => gc.id)
        end
      end
    end
  end
  
end
