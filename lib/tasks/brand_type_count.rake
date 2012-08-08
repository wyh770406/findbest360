namespace :bt do
  desc 'count brand_type products'
  task :count => :environment do
    BrandType.all.each do |bt|
      p bt.name
      ps = bt.products.where({:price.ne=>nil,:price.gt=>0})
      prices = ps.map(&:price).compact
      high_price = prices.max
      low_price = prices.min
      merchant_num = ps.map(&:merchant_id).uniq.compact.size
      sum_click = ps.map(&:click_count).compact.sum
      iorder_num = bt.order_num.to_i
      
      bt.update_attributes!({:high_price => high_price , :low_price => low_price, :merchant_num => merchant_num, :sum_click => sum_click, :order_num => iorder_num})
    end 
  end
end
