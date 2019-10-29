RSpec.describe Adjective::Inventory do

  before(:example) do
    # Clear globals as we need to track specific items by their instance_id to test them appropriately.
    reset_adj_globals

    @item = Adjective::Item.new({ name: "Potato"}) #1
    @stick = Adjective::Item.new({ name: "Stick"}) #2
    @wool = Adjective::Item.new({ name: "Wool"}) #3

    @full_health_potion = SurrogateItem.new({id: 1,  name: "Healing Potion"}) #4
    @full_mana_potion = SurrogateItem.new({id: 2,  name: "Mana Potion", uses: 2, potency: 8}) #5
    @partial_health_potion = SurrogateItem.new({id: 1,  name: "Healing Potion", uses: 1, potency: 8}) #6
    @quiver = SurrogateItem.new({id: 3,  name: "Quiver"}) #7
    @empty_quiver = SurrogateItem.new({id: 3,  name: "Quiver", ammunition: 0}) #8

    @inventory = Adjective::Inventory.new([@item, @item, @item, @item])
    @diverse_inventory = Adjective::Inventory.new([@item, @stick, @wool, @item, @stick, @wool])
    @extended_inventory = Adjective::Inventory.new([@full_mana_potion, @full_health_potion, @partial_health_potion, @quiver, @empty_quiver ])
  end


  context "when initialized it" do 

    it "will accept no items as an argument" do 
      expect(Adjective::Inventory.new().items.length).to eq(0)
    end

    it "will accept an empty items array as an argument" do 
      expect(Adjective::Inventory.new([]).items.length).to eq(0)
    end    

    it "will work when provded with an array argument of items" do 
      inventory = Adjective::Inventory.new([@item, @item])
      expect(inventory.items.length).to be(2)
    end

  end

  context "when sorting items" do 

    context "when calling #sort!" do 
      it "will sort items by created_at by default" do 
        @diverse_inventory.items.shuffle!
        @diverse_inventory.sort!
        expect(@diverse_inventory.items[0].instance_id).to eq(1)
        expect(@diverse_inventory.items[-1].instance_id).to eq(3)
      end

    end

    context "when calling #sort_by!" do 

      it "will sort items by the given attribute" do 
        @diverse_inventory.items.shuffle!
        @diverse_inventory.sort_by!(:name)
        expect(@diverse_inventory.items[0].name).to eq("Potato")
        expect(@diverse_inventory.items[-1].name).to eq("Wool")
      end

      it "will throw a RuntimeError if the given attribute/method is not present in the item set" do 
        expect{@diverse_inventory.sort_by!(:arbitrary)}.to raise_error(RuntimeError)
      end

    end
  end

  context "when items are sorted" do 

    context "when calling #sort" do 
      it "will #sort by #created_at" do 
        @diverse_inventory.items.shuffle!
        expect(@diverse_inventory.sort[0].instance_id).to eq(1)
        expect(@diverse_inventory.sort[-1].instance_id).to eq(3)
      end

      it "#sort will not amend the original item set" do 
        @diverse_inventory.sort
        expect(@diverse_inventory.items[2].instance_id).to eq(3)
      end

    end

    context "when calling #sort_by" do 
      it "will sort by the given attribute" do 
        @diverse_inventory.items.shuffle!
        inventory = @diverse_inventory.sort_by(:name)

        expect(inventory[0].name).to eq("Potato")
        expect(inventory[-1].name).to eq("Wool")
      end

      it "will not amend the original item set" do 
        @diverse_inventory.sort_by(:name)
        expect(@diverse_inventory.items[2].instance_id).to eq(3)
      end

      it "will raise a RuntimeError if the item does not respond to the given method/attribute" do  
        expect{@diverse_inventory.sort_by(:arbitrary)}.to raise_error(RuntimeError)
      end 

    end
  end

  context "when #dump methods are called" do 

    it "will #dump_by! the correct items by attribute" do 
      expect(@diverse_inventory.items.length).to eq(6)
      dumped_items = @diverse_inventory.dump_by!(:name, "Wool")

      expect(dumped_items.select {|item| item.name == "Wool"}.length).to eq(2)
      expect(@diverse_inventory.items.select {|item| item.name != "Wool"}.length).to eq(4)
    end

    it "will #dump and return the inventory completely" do 
      ground = @diverse_inventory.dump

      expect(@diverse_inventory.items.length).to eq(0)
      expect(ground.length).to eq(6)
    end
            
  end

  context "when empty? is called" do 
    it "will return true if the inventory has no items" do 
      @diverse_inventory.items = []
      expect(@diverse_inventory.empty?).to eq(true)
    end

    it "will return false if the inventory has items" do 
      expect(@diverse_inventory.empty?).to eq(false)
    end
  end

  context "when querying for items" do 
    # it "#get will locate an item" do 
    #   @diverse_inventory.get
    # end
  end

end