namespace :groupbuy do
  desc 'init groupbuy infomation.'
  task :init => :environment do
    p "init cities"
    GroupbuyCity.destroy_all
    GroupbuyCity.get_meituan_cities
    p "init hot_cities"
    GroupbuyCity.hot_cities
    p "init sites"
    GroupbuySite.destroy_all
    GroupbuySite.create_sites
    p "init categories"
    GroupbuySubcate.destroy_all
    GroupbuyCate.destroy_all
    GroupbuyCate.create_categories_from_yaml
    p "init groupbuy data"
    GroupbuyProduct.destroy_all
    GroupbuyProduct.get_groupbuy_products
  end
end 
