RSpec.describe Adjective::Item do 
  before(:example) do
    reset_adj_globals    
    # Before action sets and uses instance_id of 1 automatically...
    @item = Adjective::Item.new()
  end

  context "when initialized" do

    it "will accept a name" do 
      expect(Adjective::Item.new({name: "Rochelle"}).name).to eq("Rochelle")
    end

    it "will automatically assign a globally incrementing instance id" do 
      # Will always initialize with 1 in the global counter, so we check that it got set appropriately. 
      expect(@item.instance_id).to eq(1)
      expect(Adjective::Item.new().instance_id).to eq(2)
      expect(Adjective::Item.new().instance_id).to eq(3)
      expect(Adjective::Item.new().instance_id).to eq(4)
    end

    it "will increment the corresponding global instance id variable" do 
      5.times {Adjective::Item.new()}
      # We iterate 5 times: 5 + 1 (@item) + 1 (counter increment after init of a model) = 7
      expect($item_instance_ref).to eq(7)
    end

  end

  context "when assigned custom instance variables" do 

    # uses are defined in spec_helper and default to 5 for this test model
    it "will respond when a getter method is called" do 
      @tomato = SurrogateItem.new({id: 1})
      expect(@tomato.uses).to eq(5)
    end

    it "will respond when a setter method is called" do 
      @tomato = SurrogateItem.new({id: 1})
      @tomato.uses = 10
      expect(@tomato.uses).to eq(10)
    end    
  end

end