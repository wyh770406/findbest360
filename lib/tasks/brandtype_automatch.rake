# encoding: utf-8 ,mbt[:e_product]
namespace :bt do
  desc 'auto match brand_type products'
  amatchbt = [{:btn=>"富士S4050",:e_product=>"数码相机"}]
  task :amatch => :environment do
    amatchbt.each do |mbt|
      bt = BrandType.where(:name=>mbt[:btn]).first
      e_p = EndProduct.where(:name=>"便携相机").first

    result = Search.query(mbt[:btn],:limit=>5000)
    ids = []
    result.each do |prod|
      ids << BSON::ObjectId(prod["id"])
    end

        mbt_products = Product.any_in(:_id =>ids).where(:price.ne=>nil,:end_product_id=>e_p.id)
      
      mbt_products.each do |mbt_product|
           puts mbt_product.title
           mbt_product.update_attributes!({:brand_id => bt.brand.id,:brand_type_id=>bt.id,:order_num=>mbt_product.order_num.to_i,:end_product_id=>BSON::ObjectId("4e5215751d41c862fc00014b")}) 
           
      end
      puts "brand type products successfully matched !!!"

    end 
  end
end
