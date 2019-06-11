def SurrogateItem
  def initialize
    # This is meant to represent a child class once Item is inherited from it. 
    @uses = 5
    @potency = 10
  end
end


RSpec.describe Adjective::Item do 
  before(:example) do
    @item = Adjective::Item.new({instance_id: 1})
  end

  context "when initialized" do
    it "will initialize if an id is passed" do
      expect(Adjective::Item.new({instance_id: 1}).instance_id).to eq(1)
    end

    it "will NOT initialize when an id is not passed" do 
      expect{Adjective::Item.new({name: "Randy"})}.to raise_error(RuntimeError)
    end

    it "will accept a name" do 
      expect(Adjective::Item.new({instance_id: 1, name: "Rochelle"}).name).to eq("Rochelle")
    end
  end

end