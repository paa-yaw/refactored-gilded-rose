require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  let!(:sulfuras) { 'Sulfuras, Hand of Ragnaros' }
  let!(:aged_brie) { 'Aged Brie' }
  let!(:backstage) { 'Backstage passes to a TAFKAL80ETC concert' }
  let!(:other) { 'other' }

  describe '#update_quality' do
    context 'when sell date is passed,' do 
      it ' quality of other decreases by 2' do
        item = Item.new(other, -1, 10)
        expect{ GildedRose.new([item]).update_quality() }.to change{ item.quality }.by(-2)
      end

      it ' quality of sulfuras does not decrease' do
        item = Item.new(sulfuras, -1, 10)
        expect{ GildedRose.new([item]).update_quality() }.not_to change{ item.quality }
      end

      it ' quality of aged brie increases by 2' do
        item = Item.new(aged_brie, -1, 10)
        expect{ GildedRose.new([item]).update_quality() }.to change{ item.quality }.by(2)
      end

      it ' quality of backstage drops to 0' do
        item = Item.new(backstage, -1, 10)
        expect{ GildedRose.new([item]).update_quality() }.to change{ item.quality }.by(-item.quality)
      end
    end

    context 'quality is never negative' do
      it 'when sell date is passed' do
        item = Item.new(other, -1, 0)
        GildedRose.new([item]).update_quality()
        expect(item.quality).not_to be < 0
      end

      it 'when sell date is passed' do
        item = Item.new(sulfuras, -1, 0)
        GildedRose.new([item]).update_quality()
        expect(item.quality).not_to be < 0
      end

      it 'when sell date is passed' do
        item = Item.new(backstage, -1, 0)
        GildedRose.new([item]).update_quality()
        expect(item.quality).not_to be < 0
      end

      it 'when sell date is passed' do
        item = Item.new(aged_brie, -1, 0)
        GildedRose.new([item]).update_quality()
        expect(item.quality).not_to be < 0
      end
    end

    context 'quality of an item is never more than 50' do
      it 'quality of other never exceeds 50' do
        item = Item.new(other, 10, 49)
        GildedRose.new([item]).update_quality()
        expect(item.quality).not_to be > 50
      end

      it 'quality of Aged Brie never exceeds 50' do
        item = Item.new(aged_brie, 10, 49)
        GildedRose.new([item]).update_quality()
        expect(item.quality).not_to be > 50
      end

      it 'quality of sulfuras never exceeds 50' do
        item = Item.new(sulfuras, 10, 49)
        GildedRose.new([item]).update_quality()
        expect(item.quality).not_to be > 50
      end

      it 'quality of Backstage never exceeds 50' do
        item = Item.new(backstage, 10, 49)
        GildedRose.new([item]).update_quality()
        expect(item.quality).not_to be > 50
      end
    end

    context 'test legendary status of Sulfuras' do
      it 'never decreases in quality even passed sell date' do
        item = Item.new(sulfuras, -1, 20)
        expect{ GildedRose.new([item]).update_quality() }.not_to change{ item.quality }
      end

      it 'never decreases in quality even passed sell date even when quality is above 50' do
        item = Item.new(sulfuras, -1, 60)
        expect{ GildedRose.new([item]).update_quality() }.not_to change{ item.quality }
      end
    end

    context 'conditions of Backstage passes' do
      it 'increases by one with more than 10 days to sell' do
        item = Item.new(backstage, 11, 30)
        expect{ GildedRose.new([item]).update_quality() }.to change{ item.quality }.by(1)
      end

      it 'increases by 2 with 10 days or less to sell' do
        item = Item.new(backstage, 9, 20)
        expect{ GildedRose.new([item]).update_quality() }.to change{ item.quality }.by(2)
      end

      it 'increases by 3 with 5 days or less to sell' do
        item = Item.new(backstage, 3, 20)
        expect{ GildedRose.new([item]).update_quality() }.to change{ item.quality }.by(3)
      end

      it 'quality drops to 0 after concert' do
        item = Item.new(backstage, -1, 49)
        GildedRose.new([item]).update_quality()
        expect(item.quality).to eq 0
      end
    end

    context 'test conjured items degrades in quality twice as fast as normal items' do
      it 'when sell date has passed' do
        item = Item.new('Conjured', -1, 40)
        expect{ GildedRose.new([item]).update_quality() }.to change{ item.quality }.by(-4)
      end
    end
  end
end
