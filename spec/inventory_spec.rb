RSpec.describe Adjective::Inventory do

  before(:example) do
    # Clear globals as we need to track specific items by their instance_id to test them appropriately.
    reset_adj_globals

    @item = Adjective::Item.new({ id: 54, name: "Potato"}) #1
    @stick = Adjective::Item.new({ id: 67, name: "Stick"}) #2
    @wool = Adjective::Item.new({ id: 89, name: "Wool"}) #3

    @full_health_potion = SurrogateItem.new({id: 1,  name: "Healing Potion"}) #4
    @full_mana_potion = SurrogateItem.new({id: 2,  name: "Mana Potion", uses: 2, potency: 8}) #5
    @partial_health_potion = SurrogateItem.new({id: 1,  name: "Healing Potion", uses: 1, potency: 8}) #6

    @quiver = SurrogateItem.new({id: 5,  name: "Quiver"}) #7
    @empty_quiver = SurrogateItem.new({id: 5,  name: "Quiver", ammunition: 0}) #8

    @inventory = Adjective::Inventory.new([@item, @item, @item, @item])
    @diverse_inventory = Adjective::Inventory.new([@item, @stick, @wool, @item, @stick, @wool])
    @extended_inventory = Adjective::Inventory.new([@full_mana_potion, @full_health_potion, @partial_health_potion, @quiver, @empty_quiver ])
    @mixed_attribute_inventory = Adjective::Inventory.new([@item, @item, @quiver, @stick, @full_health_potion])

    @child_inventory = SurrogateInventory.new("Backpack", 1, [@full_health_potion, @partial_health_potion, @stick, @wool, @quiver])
    @limited_inventory = Adjective::Inventory.new([@item, @item, @quiver, @stick, @full_health_potion], {max_size: 8})
  end

  context "when using a child model" do 
    it "should retain items" do 
      expect(@child_inventory.items.length).to eq(5)
    end

    it "methods should be able to be overidden" do 
      expect(@child_inventory.sort.map {|item| item.instance_id}).to eq([4, 6, 7, 2, 3])
    end
  end

  context "when initialized" do 

    it "will accept no items as an argument" do 
      expect(Adjective::Inventory.new().items.length).to eq(0)
    end

    it "will accept an empty items array as an argument" do 
      expect(Adjective::Inventory.new([]).items.length).to eq(0)
    end    

    it "will accept an array argument of items" do 
      inventory = Adjective::Inventory.new([@item, @item])
      expect(inventory.items.length).to be(2)
    end

    it "will set max_size to :unlimited by default" do
      default_inventory = Adjective::Inventory.new
      expect(default_inventory.max_size).to eq(:unlimited)
    end

    it "will set max_size from :max_size option" do 
      expect(@limited_inventory.max_size).to eq(8)
    end

    it "will throw an error if the provided items array is longer than the max_size" do 
      expect{Adjective::Inventory.new([@item, @item, @item, @item],{max_size: 1})}.to raise_error(ArgumentError)
    end

  end

  context "when items are retrieved" do 
    it "will #retrieve using instance_id" do 
      sample = @extended_inventory.items.sample
      expect(@extended_inventory.retrieve(sample.instance_id)).to eq(sample)
    end

    it "will #retrieve_by an attribute and value" do 
      expect(@diverse_inventory.retrieve_by(:name, "Stick").length).to eq(2)
    end

    it "#retrieve_by will not error out when asked to work with an attribute that doesn't exist" do 
      expect(@diverse_inventory.retrieve_by(:arbitrary, "Stick")).to eq([])
    end

    it "will correctly use alias method get" do 
      sample = @extended_inventory.items.sample
      expect(@extended_inventory.get(sample.instance_id)).to eq(sample)      
    end

    it "will correctly use alias method get_by" do 
      expect(@diverse_inventory.get_by(:name, "Stick").length).to eq(2)
    end

    it "will correctly use alias method find" do 
      sample = @extended_inventory.items.sample
      expect(@extended_inventory.find(sample.instance_id)).to eq(sample)      
    end

    it "will correctly use alias method find_by" do 
      expect(@diverse_inventory.find_by(:name, "Stick").length).to eq(2)
    end    
  end

  context "when sorting items destructively" do 

    context "when calling #sort!" do 
      it "will sort items by created_at by default" do 
        @diverse_inventory.items.shuffle!
        @diverse_inventory.sort!
        expect(@diverse_inventory.items[0].instance_id).to eq(1)
        expect(@diverse_inventory.items[-1].instance_id).to eq(3)
      end

      it "will throw a RuntimeError if the given attribute/method is not present in the item set" do 
        expect{@diverse_inventory.sort_by(:arbitrary)}.to raise_error(RuntimeError)
      end

      it "will throw an ArgumentError if there is an invalid order argument" do 
         expect{@diverse_inventory.sort_by(:name, :arbitrary)}.to raise_error(ArgumentError)
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

      it "will throw an ArgumentError if there is an invalid order argument" do 
         expect{@diverse_inventory.sort_by!(:name, :arbitrary)}.to raise_error(ArgumentError)
      end

    end
  end

  context "when items are sorted and return new arrays" do 

    context "when calling #sort" do 
      it "will #sort by #created_at by default" do 
        @diverse_inventory.items.shuffle!
        expect(@diverse_inventory.sort[0].instance_id).to eq(1)
        expect(@diverse_inventory.sort[-1].instance_id).to eq(3)
      end

      it "#sort will not amend the original item set" do 
        @diverse_inventory.sort
        expect(@diverse_inventory.items[2].instance_id).to eq(3)
      end

      it "will sort by default_sort attribute" do 
        inventory = Adjective::Inventory.new([@item, @item, @quiver, @stick, @full_health_potion], {default_sort_method: :name})
        inventory.items.shuffle!
        ordered_inventory = inventory.sort
        expect(ordered_inventory[0].name).to eq("Healing Potion")
        expect(ordered_inventory[-1].name).to eq("Stick")
      end

      it "will throw an error if value for default_sort_method does not exist on all items" do 
        expect{Adjective::Inventory.new([@item, @item, @quiver, @stick, @full_health_potion], {default_sort_method: :arbitrary})}.to raise_error(RuntimeError)
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

      it "will throw an ArgumentError if there is an invalid order argument" do 
         expect{@diverse_inventory.sort_by(:name, :arbitrary)}.to raise_error(ArgumentError)
      end      

    end
  end

  context "when #dump methods are called" do 

    it "will #dump_by the correct items by attribute" do 
      expect(@diverse_inventory.items.length).to eq(6)
      dumped_items = @diverse_inventory.dump_by(:name, "Wool")

      expect(dumped_items.select {|item| item.name == "Wool"}.length).to eq(2)
      expect(@diverse_inventory.items.select {|item| item.name != "Wool"}.length).to eq(4)
    end

    it "will correctly use alias method clear_by" do 
      expect(@diverse_inventory.items.length).to eq(6)
      dumped_items = @diverse_inventory.clear_by(:name, "Wool")

      expect(dumped_items.select {|item| item.name == "Wool"}.length).to eq(2)
      expect(@diverse_inventory.items.select {|item| item.name != "Wool"}.length).to eq(4)
    end    

    it "will #dump and return the inventory completely" do 
      ground = @diverse_inventory.dump
      expect(@diverse_inventory.items.length).to eq(0)
      expect(ground.length).to eq(6)
    end

    it "will correctly use alias method clear" do 
      ground = @diverse_inventory.clear
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

  context "when storing items" do 
    it "will store one item" do 
      @diverse_inventory.store(@item)
      expect(@diverse_inventory.items.length).to eq(7)
    end

    it "will store multiple items" do 
      @diverse_inventory.store([@item, @item, @item])
      expect(@diverse_inventory.items.length).to eq(9)
    end   

    it "will store items if the inventory is not full" do
      expect(@limited_inventory.items.length).to eq(5)
      @limited_inventory.store([@item, @item, @item])
      expect(@limited_inventory.items.length).to eq(8)
    end 

    it "will return false if inventory is not able to accept more items" do 
      expect(@limited_inventory.store([@item, @item, @item, @item, @item])).to eq(false)
    end

    it "will correctly use alias method deposit" do 
      @diverse_inventory.deposit(@item)
      expect(@diverse_inventory.items.length).to eq(7)      
    end

    it "will correctly use alias method put" do 
      @diverse_inventory.put(@item)
      expect(@diverse_inventory.items.length).to eq(7)      
    end    
  end

  context "when querying for items" do 
    it "will return results" do 
      expect(@child_inventory.query("Wool").length).to eq(1)
      expect(@child_inventory.query("100").length).to eq(3)
    end

    it "will return no results if no matches are made" do 
      expect(@child_inventory.query("arbitrary").length).to eq(0)
    end

    it "will throw argument error if an incorrect scope is passed given" do
      expect{@child_inventory.query("Quiver", :arbitrary)}.to raise_error(ArgumentError) 
    end

    it "will correctly interpret alias method of search" do 
      expect(@child_inventory.search("Wool").length).to eq(1)
      expect(@child_inventory.search("100").length).to eq(3)
    end
  end

  context "when empty slots is called" do 
    it "returns the appropriate number" do 
      expect(@limited_inventory.empty_slots).to eq(3)
    end

    it "returns :unlimited if no max_size is set" do 
      expect(@diverse_inventory.empty_slots).to eq(:unlimited)
    end
  end

end