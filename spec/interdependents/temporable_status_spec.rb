RSpec.describe "Temporable integration with Status" do
  before(:example) do 
    @renew = SurrogateStatus.new("Renew", {affected_attributes: { hitpoints: 3}, max_duration: 5})
    @agony = SurrogateStatus.new("Agony", {affected_attributes: { hitpoints: -3}, max_duration: 10})
    @rend = SurrogateStatus.new("Rend", {affected_attributes: { hitpoints: 1}})
  end

  describe "when a status initializes" do 
    it "will set duration values correctly" do 
      expect(@renew.max_duration).to eq(5)
      expect(@renew.remaining_duration).to eq(5)
    end

    it "will default to 1 if no initial duration is set" do
      expect(@rend.max_duration).to eq(1)
      expect(@rend.remaining_duration).to eq(1)
    end

    it "will throw an error if provided @remaining_duration is larger than @max_duration" do
      expect{SurrogateStatus.new("Deadly Poison", {affected_attributes: { hitpoints: -2}, remaining_duration: 11, max_duration: 10})}
      .to raise_error(ArgumentError)
    end    

    it "will map to @affected_attributes properly" do
      expect(@renew.affected_attributes).to include(:@hitpoints)
      expect(@renew.affected_attributes.length).to eq(1)
    end
  end

  describe "when utility methods are called" do 
    it "#expired? will correctly tell if a status is expired" do 
      # Assumes default of 1 is present.
      @rend.remaining_duration -= 1
      expect(@rend.expired?).to eq(true)
    end

    it "#expiring? will correctly tell if a status is about to expire" do 
      expect(@rend.expiring?).to eq(true)
    end

    it "#max_duration? will correctly tell if the status is at max duration" do 
      expect(@rend.max_duration?).to eq(true)
    end
  end  

end