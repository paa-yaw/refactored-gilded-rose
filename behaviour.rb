module Behaviour
    class ItemWrapper 
      attr_accessor :item 

      ITEM_BEHAVIOUR_HASH = {
        'Aged Brie' => 'aged_brie',
        'Backstage passes to a TAFKAL80ETC concert' => 'backstage_pass',
        'Sulfuras, Hand of Ragnaros' => 'sulfuras',
        'Conjured' => 'conjured'
      }
  
      def initialize(item)
        @item = item
      end
      
      def behaviour
        case item.name 
        when ITEM_BEHAVIOUR_HASH.key(ITEM_BEHAVIOUR_HASH[item.name])
        __send__("#{ITEM_BEHAVIOUR_HASH[item.name]}_behaviour".to_sym, item)
        else 
          normal_behaviour(item)
        end
      end

      private
  
      def normal_behaviour(item)
        return item.quality if item.quality < 2 
        decrement_quality(item, 2) if item.sell_in < 0
      end
  
      def backstage_pass_behaviour(item)
        return item.quality if item.quality > 46 && item.sell_in > 0    
        
        if item.sell_in > 10
          increment_quality(item, 1) 
        elsif item.sell_in <= 5 && item.sell_in > 0 
          increment_quality(item, 3)
        elsif item.sell_in <=10 && item.sell_in > 0
          increment_quality(item, 2)
        elsif item.sell_in < 0 
          item.quality = 0 
        end
      end
  
      def aged_brie_behaviour(item)
        increment_quality(item, 2) if item.sell_in < 0
      end
  
      def sulfuras_behaviour(item)
        return item.quality
      end
  
      def conjured_behaviour(item)
        return item.quality if item.quality < 2 
        decrement_quality(item, 4) if item.sell_in < 0
      end
    end
  end