# coding: utf-8
class Search
  BRAND_MAP = [
    ["nokia", "诺基亚"]
  ]
  attr_accessor :type, :title, :id, :exts
  def initialize(options = {})
    self.exts = []
    options.keys.each do |k|
      eval("self.#{k} = options[k]")
    end
  end

  def self.key_prefix
    "findbest360.searchs"
  end

  def self.generate_key(title,type)
    "#{Search.key_prefix}#!##{title.downcase}#!##{type}"
  end

  def save
    data = {:title => self.title, :id => self.id, :type => self.type}
    self.exts.each do |f|
      data[f[0]] = f[1]
    end
    
    key = Search.generate_key(self.title,self.type)
    res = $redis.set key, data.to_json
    if res == "OK"
      self.save_zindex(key)
      return true
    end
    false
  end

  def save_zindex(key)
    key_array = key.split("#!#")
    rkey = "#{self.type}#!##{key_array[1].downcase}"
    (1..(rkey.length)).each do |l|
      prefix = rkey[0...l]
      $redis.zadd(Search.key_prefix, 0, prefix)
    end
    $redis.zadd(Search.key_prefix, 0, rkey + "*")
  end

  def self.remove(options = {})
    $redis.del(generate_key(options[:title],options[:type]))
  end

  def self.complete(w, options = {})
    count = options[:limit] || 10 
    type = options[:type] || "Topic"
    key_matchs = []
    rangelen = 100 # This is not random, try to get replies < MTU size
    prefix = "#{type}#!##{w.downcase}"
    start = $redis.zrank(Search.key_prefix,prefix)
    return [] if !start
    while key_matchs.length != count
      range = $redis.zrange(Search.key_prefix,start,start+rangelen-1)
      start += rangelen
      break if !range or range.length == 0
      range.each {|entry|
        minlen = [entry.length,prefix.length].min
        if entry[0...minlen] != prefix[0...minlen]
          count = key_matchs.count
          break
        end
        if entry[-1..-1] == "*" and key_matchs.length != count
          key_matchs << entry[0...-1]
        end
      }
    end
    keys = []
    key_matchs.uniq.each do |k|
      ktype, rkey = k.split("#!#")
      next if ktype.blank? or rkey.blank?
      keys << self.generate_key(rkey, ktype)
    end
    result = []
    return result if keys.blank?
    $redis.mget(*keys).each do |r|
      begin
        result << JSON.parse(r)
      rescue => e
        Rails.logger.info { "Search.query failed: #{e}" }
      end
    end
    result
  end

  def self.query(text,options = {})
    return [] if text.strip.blank?

    origin_words = Product.mmseg_text(text)

    words_arr = []
    words_arr << origin_words


    for brand in BRAND_MAP
      conversion_words =  Array.new(origin_words)
      if conversion_words.include?(brand[0])
        brand_index = conversion_words.index(brand[0])
        conversion_words[brand_index] = brand[1]
        Rails.logger.debug { "conversion_words:#{conversion_words}" }
        words_arr << conversion_words
      end
    end
    limit = options[:limit] || 10
    Rails.logger.debug { "words_arr:#{words_arr}" }
    keys = []
    words_arr.each do |words|
      word_match = words.collect(&:downcase).join("*")
      #     puts word_match
      reg = "#{Search.key_prefix}#!#*#{word_match}*#!#Product"
      keys += $redis.keys(reg)[0,limit]
    end

    keys = keys.uniq[0,limit]
    #  puts keys
    result = []
    return result if keys.blank?
    $redis.mget(*keys).each do |r|

      begin
        record_json = JSON.parse(r)
        id_str = record_json["id"]
        
        result << BSON::ObjectId(id_str)
      rescue => e
        Rails.logger.info { "Search.query failed: #{e}" }
      end
    end
    result
  end
  
  def self.sort_result(items, type)
    return items if items.blank?
    case type
    when "Topic"
      items = items.sort { |x,y| y['followers_count'] <=> x['followers_count'] }
    when "User"
      items = items.sort { |x,y| y['score'] <=> x['score'] }
    end
    items
  end
end
