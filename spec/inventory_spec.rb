class SurrogateItem < Adjective::Item
  def initialize(attributes)
    # This is meant to represent a child class once Item is inherited from it.
    super(attributes)
    raise RuntimeError, "'#{attribute}' is not present in attributes set: #{attributes}" if !attributes.key?(:id) 
    @id = attributes[:id]
    @uses = attributes[:uses] ||= 5
    @potency = attributes[:potency] ||= 10
    @ammunition = attributes[:ammunition] ||= 100
  end
end  

RSpec.describe Adjective::Inventory do

  before(:example) do
    @item = Adjective::Item.new({instance_id: 1, name: "Potato"})
    @stick = Adjective::Item.new({instance_id: 2, name: "Stick"})
    @wool = Adjective::Item.new({instance_id: 3, name: "Wool"})

    @full_health_potion = SurrogateItem.new({id: 1, instance_id: 5, name: "Healing Potion"})
    @full_mana_potion = SurrogateItem.new({id: 2, instance_id: 6, name: "Mana Potion", uses: 2, potency: 8})
    @partial_health_potion = SurrogateItem.new({id: 1, instance_id: 7, name: "Healing Potion", uses: 1, potency: 8})
    @quiver = SurrogateItem.new({id: 3, instance_id: 8, name: "Quiver"})
    @empty_quiver = SurrogateItem.new({id: 3, instance_id: 9, name: "Quiver", ammunition: 0})

    @inventory = Adjective::Inventory.new([@item, @item, @item, @item])
    @diverse_inventory = Adjective::Inventory.new([@item, @stick, @wool, @item, @stick, @wool])
    @extended_inventory = Adjective::Inventory.new([@full_mana_potion, @full_health_potion, @partial_health_potion, @quiver, @empty_quiver ])
  end

  context "when initialized" do 

    it "will initialize if items argument isn't passed" do 
      expect(Adjective::Inventory.new().items.length).to eq(0)
    end

    it "will initialize if provded with an array of items" do 
      inventory = Adjective::Inventory.new([@item, @item])
      expect(inventory.items.length).to be(2)
    end

  end

  context "when items are grouped" do 
    it "will group them by id" do 
      expect(@diverse_inventory.grouped_items[1].length).to eq(2)
      expect(@diverse_inventory.grouped_items[2].length).to eq(2)
    end

    it "will not take nil values" do 
      expect{Adjective::Inventory.new([@item, nil])}.to raise_error(RuntimeError)
    end
  end

  context "when find with an id is called" do 
    it "will return the items with corresponding id" do 
      expect(@diverse_inventory.find_by_instance_id(1)).to eq([@item, @item])
    end
  end

  context "when sorting items using dangerous methods" do 
    context "when calling #sort!" do 
      it "will sort items by instance_id by default" do 
        @diverse_inventory.sort!
        expect(@diverse_inventory.items[0].instance_id).to eq(1)
        expect(@diverse_inventory.items[-1].instance_id).to eq(3)
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

  context "sort_grouped_items_by! destructive method" do 
    it "will sort by key by default" do 
      p @extended_inventory.items.each {|item| p item }
      # p @diverse_inventory.sort_grouped_items_by!(:name)
    end 
  end

  context "when items are sorted with non-dangerous methods" do 
    it "will #sort by id by default" do 
      expect(@diverse_inventory.sort[0].instance_id).to eq(1)
      expect(@diverse_inventory.sort[-1].instance_id).to eq(3)
    end

    it "#sort will not amend the original item set" do 
      @diverse_inventory.sort
      expect(@diverse_inventory.items[2].instance_id).to eq(3)
    end

    it "will raise a RuntimeError if the item does not respond to the given method/attribute" do 
      expect{@diverse_inventory.sort_grouped_items_by(:rolos)}.to raise_error(RuntimeError)
    end
  end

end