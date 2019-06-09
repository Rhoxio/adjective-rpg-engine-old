RSpec.describe Inventory do

  before(:example) do
    @item = Item.new({id: 1, name: "Potato"})
    @stick = Item.new({id: 2, name: "Stick"})
    @wool = Item.new({id: 3, name: "Wool"})

    @inventory = Inventory.new([@item, @item, @item, @item])
    @diverse_inventory = Inventory.new([@item, @stick, @item, @stick, @wool, @wool])
  end

  context "when initialized" do 

    it "will initialize if items argument isn't passed" do 
      expect(Inventory.new().items.length).to eq(0)
    end

    it "will initialize if provded with an array of items" do 
      inventory = Inventory.new([@item, @item])
      expect(inventory.items.length).to be(1)
      expect(inventory.items[1].length).to be(2)
    end

  end

  context "when items are grouped" do 
    it "will group them by id" do 
      expect(@diverse_inventory.items[1].length).to eq(2)
      expect(@diverse_inventory.items[2].length).to eq(2)
    end

    it "will not take nil values" do 
      expect{Inventory.new([@item, nil])}.to raise_error(RuntimeError)
    end
  end

end