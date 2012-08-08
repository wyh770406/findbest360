namespace :groupbuy do
  desc 'get groupbuy products.'
  task :products => :environment do
    GroupbuyProduct.destroy_all
    GroupbuyProduct.get_groupbuy_products
  end
end 