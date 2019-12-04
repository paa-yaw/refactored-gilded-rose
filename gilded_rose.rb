require File.join(File.dirname(__FILE__), 'behaviour')

class GildedRose
  include Behaviour
  attr_accessor :items

  def initialize(items)
    @items = items
  end

  def update_quality()
    items.each do |item|
      ItemWrapper.new(item).behaviour
    end
  end
end

def increment_quality(item, n) 
  n.times { item.quality += 1 }
end

def decrement_quality(item, n) 
  n.times { item.quality -= 1 }
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
