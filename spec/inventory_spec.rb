RSpec.describe Inventory do

  context "when initialized" do 

    it "will initialize if items argument isn't passed" do 
      expect(Inventory.new().items.length).to eq(0)
    end

    it "will initialize if provded with any array of objects" do 
      inventory = Inventory.new([1,2])
      expect(inventory2.items.length).to be(2)
    end

  end

end