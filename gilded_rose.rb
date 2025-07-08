def update_quality(items)
  items.each do |item|
    update_item_quality(item)
    update_sell_in(item)
    handle_expired_item(item)
  end
end

private

def update_item_quality(item)
  case item.name
  when 'Aged Brie'
    increase_quality(item)
  when 'Backstage passes to a TAFKAL80ETC concert'
    update_backstage_pass_quality(item)
  when 'Sulfuras, Hand of Ragnaros'
    # Sulfuras never changes quality
  else
    decrease_quality(item, conjured_degradation_factor(item))
  end
end

def update_sell_in(item)
  item.sell_in -= 1 unless item.name == 'Sulfuras, Hand of Ragnaros'
end

def handle_expired_item(item)
  return if item.sell_in >= 0
  
  case item.name
  when 'Aged Brie'
    increase_quality(item)
  when 'Backstage passes to a TAFKAL80ETC concert'
    item.quality = 0
  when 'Sulfuras, Hand of Ragnaros'
    # Sulfuras never changes
  else
    decrease_quality(item, conjured_degradation_factor(item))
  end
end

def update_backstage_pass_quality(item)
  increase_quality(item)
  
  if item.sell_in <= 10
    increase_quality(item)
  end
  
  if item.sell_in <= 5
    increase_quality(item)
  end
end

def increase_quality(item)
  item.quality += 1 if item.quality < 50
end

def decrease_quality(item, factor = 1)
  item.quality -= factor if item.quality > 0
end

def conjured_degradation_factor(item)
  item.name.start_with?('Conjured') ? 2 : 1
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

