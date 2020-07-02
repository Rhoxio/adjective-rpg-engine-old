RSpec.describe Adjective::Status do  
  before(:example) do 
    @renew = SurrogateStatus.new("Renew", {affected_attributes: { hitpoints: 3}, max_duration: 5})
    @agony = SurrogateStatus.new("Agony", {affected_attributes: { hitpoints: -3}, max_duration: 10})
    @rend = SurrogateStatus.new("Rend", {affected_attributes: { hitpoints: 1}})
  end

  describe "when attributes are added" do 
    it "will warn the user is a duplicate key is present" do 

    end
  end

  describe "when tick is called" do 
    it "will reduce the @remaining_duration by default" do 
      @renew.tick
      expect(@renew.remaining_duration).to eq(4)
    end

    it "will allow for a block" do 
      @renew.tick do |status|
        expect(status.max_duration).to eq(5)
      end
    end

    it "will allow for attributes to be amended in block" do 
      @renew.tick do |status|
        status.max_duration = 10
        status.remaining_duration = 8
      end
      expect(@renew.max_duration).to eq(10)
      expect(@renew.remaining_duration).to eq(8)
    end

    it "will return an amended version of the parent object" do 
      klass = @renew.tick
      expect(klass.remaining_duration).to eq(4)
    end
  end

end