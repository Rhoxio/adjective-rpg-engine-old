RSpec.describe Inventory do

  before(:example) do
    @item = Item.new({id: 1, name: "Potato"})
    @stick = Item.new({id: 2, name: "Stick"})
    @wool = Item.new({id: 3, name: "Wool"})

    @inventory = Inventory.new([@item, @item, @item, @item])
    @diverse_inventory = Inventory.new([@item, @stick, @wool, @item, @stick, @wool])
  end

  context "when initialized" do 

    it "will initialize if items argument isn't passed" do 
      expect(Inventory.new().items.length).to eq(0)
    end

    it "will initialize if provded with an array of items" do 
      inventory = Inventory.new([@item, @item])
      expect(inventory.items.length).to be(2)
    end

  end

  context "when items are grouped" do 
    it "will group them by id" do 
      expect(@diverse_inventory.grouped_items[1].length).to eq(2)
      expect(@diverse_inventory.grouped_items[2].length).to eq(2)
    end

    it "will not take nil values" do 
      expect{Inventory.new([@item, nil])}.to raise_error(RuntimeError)
    end
  end

  context "when find with an id is called" do 
    it "will return the items with corresponding id" do 
      expect(@diverse_inventory.find_by_id(1)).to eq([@item, @item])
    end
  end

  context "when sorting items using dangerous methods" do 
    context "when calling #sort!" do 
      it "will sort items by id by default" do 
        @diverse_inventory.sort!
        expect(@diverse_inventory.items[0].id).to eq(1)
        expect(@diverse_inventory.items[-1].id).to eq(3)
      end
    end

    context "when calling #sort_by!" do 
      it "will sort items by the given attribute" do 
        @diverse_inventory.sort_by!(:name)
        expect(@diverse_inventory.items[0].name).to eq("Potato")
        expect(@diverse_inventory.items[-1].name).to eq("Wool")
      end

      it "will throw a RuntimeError if the given attribute/method is not present in the item set" do 
        expect{@diverse_inventory.sort_by!(:rolos)}.to raise_error(RuntimeError)
      end
    end
  end

  context "when items are sorted with non-dangerous methods" do 
    it "will #sort by id by default" do 
      expect(@diverse_inventory.sort[0].id).to eq(1)
      expect(@diverse_inventory.sort[-1].id).to eq(3)
    end

    it "#sort will not amend the original item set" do 
      @diverse_inventory.sort
      expect(@diverse_inventory.items[2].id).to eq(3)
    end

    it "will raise a RuntimeError if the item does not respond to the given method/attribute" do 
      expect{@diverse_inventory.sort_grouped_items_by(:rolos)}.to raise_error(RuntimeError)
    end
  end

end