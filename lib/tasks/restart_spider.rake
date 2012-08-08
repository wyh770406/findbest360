namespace :spider do
  desc 'restart the stopped spider'
  task :restart => :environment do
    product_count = ProductUrl.where({:kind => "dangdang", :compeleted => false}).size
    if product_count.size > 0
      str = ""
      IO.popen("ps x | grep 'ruby script/run_parser -s dangdang -eproduction' | grep -v 'grep' | awk '{print $1}'") {|f| str += f.gets if f.gets}
      pid_arr = str.split("\n")
      if pid_arr.size < 2
        `cd /home/hupengxing/works/etao/spider;nohup ruby script/run_parser -s dangdang -eproduction -n1000000 &`
      end
    end
  end
end 
