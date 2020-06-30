RSpec.describe Adjective::Statusable do
  before(:example) do
    @heal = Adjective::Status.new("heal", { affected_attributes: { hitpoints: 5 }})
    @agony = Adjective::Status.new("Agony", { duration: 12, affected_attributes: { hitpoints: -3 }})
    @gender_bender = Adjective::Status.new("Gender Bender", {affected_attributes: {gender: "male"}})

    @bind = Adjective::Status.new("bind", { duration: 1, affected_attributes: { hitpoints: -1 }})
    @sap = Adjective::Status.new("sap", {duration: 5, affected_attributes: {hitpoints: 0} })

    @actor = SurrogateActor.new("DefaultDude", {exp_table: [0,200,300,400,500,600,700,800,900,1000, 1200]})     
  end

  describe "when utility methods are called" do 
    it "will accurately tell if the status is instant" do 
      expect(@heal.instant?).to eq(true)
      expect(@heal.over_time?).to eq(false)
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
      expect(@actor.apply_status(@heal).length).to eq(1)
    end 

    it "will allow for a block argument" do 
      @actor.apply_status(@heal) do |model, status|
        expect(model.name).to eq("DefaultDude")
        expect(status.name).to eq("heal")
      end
    end
  end

  describe "when statuses are cleared" do 
    it "will keep unexpired statuses" do 
      @actor.apply_status(@bind)
      @actor.apply_status(@sap)
      @actor.tick_all
      @actor.tick_all
      ap @actor.statuses
    end
  end

  describe "when statuses tick" do 
    it "will accept a block" do 
      @actor.apply_status(@heal)
      @actor.apply_status(@agony)
      @actor.tick_all do |model, statuses|
        expect(model.name).to eq("DefaultDude")
        expect(statuses.length).to eq(2)
      end
    end

    it "will tick all numeric statuses" do 
      @actor.apply_status(@heal)
      @actor.apply_status(@agony)
      @actor.tick_all
      expect(@actor.hitpoints).to eq(3)
    end

    it "will amend non-numeric attributes" do 
      @actor.apply_status(@gender_bender)
      @actor.tick_all
      expect(@actor.gender).to eq("male")
    end
  end

end