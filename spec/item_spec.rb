RSpec.describe Item do 
  before(:example) do
    @item = Item.new({id: 1})
  end

  context "when initialized" do
    it "will initialize if an id is passed" do
      expect(Item.new({id: 1}).id).to eq(1)
    end

    it "will NOT initialize when an id is not passed" do 
      expect{Item.new({name: "Randy"})}.to raise_error(RuntimeError)
    end

    it "will accept a name" do 
      expect(Item.new({id: 1, name: "Rochelle"}).name).to eq("Rochelle")
    end
  end
  
end