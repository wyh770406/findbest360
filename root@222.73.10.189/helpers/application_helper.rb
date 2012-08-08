# coding: utf-8
module ApplicationHelper
  def pagetitle(page_title)
    content_for :title do
      "#{page_title} - 易淘比购"
    end
  end

  # add stylesheet file into header tag
  def add_stylesheet name, yield_name = :stylesheet_file
    content_for yield_name, stylesheet_link_tag(name)
  end

  # add javascript file into header tag
  def add_javascript name, yield_name = :javascript_file
    content_for yield_name, javascript_include_tag(name)
  end

  def errors_for(object, message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class='formErrors #{object.class.name.humanize.downcase}Errors'>\n"
      if message.blank?
        if object.new_record?
          html << "\t\t<h5>There was a problem creating the #{object.class.name.humanize.downcase}</h5>\n"
        else
          html << "\t\t<h5>There was a problem updating the #{object.class.name.humanize.downcase}</h5>\n"
        end
      else
        html << "<h5>#{message}</h5>"
      end
      html << "\t\t<ul>\n"
      object.errors.full_messages.each do |error|
        html << "\t\t\t<li>#{error}</li>\n"
      end
      html << "\t\t</ul>\n"
      html << "\t</div>\n"
    end
    html
  end

  # 去除区域里面的内容的换行标记
  def spaceless(&block)
    data = with_output_buffer(&block)
    data = data.gsub(/\n\s+/," ")
    data = data.gsub(/>\s+</,"> <")
    data
  end
  
  #团购分类数量
  def products_count(c, city, c_or_s)
    count = 0
    if c_or_s == 'c'
      count = GroupbuyProduct.count(:conditions => {:groupbuy_cate_id => c.id, :groupbuy_city_id => city.id})
    else
      count = GroupbuyProduct.count(:conditions => {:groupbuy_subcate_id => c.id, :groupbuy_city_id => city.id})
    end
    return count
  end
end
