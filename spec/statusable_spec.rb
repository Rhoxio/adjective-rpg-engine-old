RSpec.describe Adjective::Statusable do
  before(:example) do
    @renew = Adjective::Status.new("Renew", { affected_attributes: { hitpoints: 5 }})
    @agony = Adjective::Status.new("Agony", { duration: 12, affected_attributes: { hitpoints: -3 }})
    @actor = SurrogateActor.new("DefaultDude", {exp_table: [0,200,300,400,500,600,700,800,900,1000, 1200]})     
  end

  describe "when utility methods are called" do 
    it "will accurately tell if the status is instant" do 
      expect(@renew.instant?).to eq(true)
      expect(@renew.over_time?).to eq(false)
    end

    it "will accurately tell if the status is over time" do 
      expect(@agony.over_time?).to eq(true)
      expect(@agony.instant?).to eq(false)
    end  

    it "will correctly convert instance variable signatures" do 
      expect(@agony.affected_attributes).to eq([:@hitpoints])
    end
  end

  describe "when statuses are applied" do 
    it "will add a status to @statuses" do 
      expect(@actor.apply_status(@renew).length).to eq(1)
    end 

    it "will allow for a block argument" do 
      @actor.apply_status(@renew) do |model, status|
        expect(model.name).to eq("DefaultDude")
        expect(status.name).to eq("Renew")
      end
    end
  end

  describe "when statuses tick" do 
    it "will accept a block" do 
      @actor.apply_status(@renew)
      @actor.apply_status(@agony)
      @actor.tick_all do |model, statuses|
        expect(model.name).to eq("DefaultDude")
        expect(statuses.length).to eq(2)
      end
    end

    it "will tick all statuses" do 
      @actor.apply_status(@renew)
      @actor.apply_status(@agony)
      @actor.tick_all
      expect(@actor.hitpoints).to eq(3)
    end
  end

end