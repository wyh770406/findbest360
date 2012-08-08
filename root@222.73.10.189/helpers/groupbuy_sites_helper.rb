# coding: utf-8
module GroupbuySitesHelper
  
  def get_cities_by_letter(letter)
    GroupbuyCity.all.select {|l| l.pinyin.first == letter.downcase}
  end
  
  def price_sort_name(num)
    name = ""
    case num
    when '1'
      name = "<10元"
    when '2'
      name = "10-50元"
    when '3'
      name = ">100元"
    end
    return name
  end
  
  
end
