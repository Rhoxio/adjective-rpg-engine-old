RSpec.describe Adjective::Temporable do
  before(:example) do 
    @renew = SurrogateStatus.new("Renew", {affected_attributes: { hitpoints: 3}, max_duration: 5})
    @agony = SurrogateStatus.new("Agony", {affected_attributes: { hitpoints: -3}, max_duration: 10})
    @rend = SurrogateStatus.new("Rend", {affected_attributes: { hitpoints: 1}})
    @malaise = SurrogateStatus.new("Malaise", {affected_attributes: { hitpoints: -1}, indefinite: true})
  end

  describe "when temporality is initialized" do 
    it "will set @indefinite to true if option is passed" do 
      expect(@malaise.indefinite).to eq(true)
    end

    it "will see if #max_duration? works as intended" do 
      expect(@renew.max_duration?).to eq(true)
      @renew.remaining_duration = 0
      expect(@renew.max_duration?).to eq(false)
    end

    it "will see if #max_duration? works with indefinite durations" do 
      expect(@malaise.max_duration?).to eq(true)
    end
  end

  describe "when durations are amended" do 
    it "will correctly extend the duration" do 
      @renew.remaining_duration -= 1
      expect(@renew.remaining_duration).to eq(4)
      @renew.extend_by(1)
      expect(@renew.remaining_duration).to eq(5)
    end

    it "will not extend duration past max" do 
      @renew.remaining_duration -= 1
      @renew.extend_by(2)
      expect(@renew.remaining_duration).to eq(5)
    end
  end

end