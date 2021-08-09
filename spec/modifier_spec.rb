RSpec.describe Adjective::Modifier do

  before(:each) do 
    @modifier = Adjective::Modifier.new("Damage", {hitpoints: 5})
  end

  describe "when initialized" do 
    it "will sandbox for me" do 
      ap @modifier
    end

    it "will accept a name attribute" do 
      expect(@modifier.name).to eq("Damage")
    end

    it "will train a default name of Unnamed Modifier" do 
      mod = Adjective::Modifier.new()
      expect(mod.name).to eq("Unnamed Modifier")
    end

    it "will not contain blank affected_attributes" do 
      mod = Adjective::Modifier.new("Big Dam")
      expect(mod.affected_attributes.empty?).to eq(true)
    end

  end

  describe "utility methods" do 
    # it "will respond to #affected_attributes" do 
    #   expect(@modifier.attributes)
    # end
  end

end