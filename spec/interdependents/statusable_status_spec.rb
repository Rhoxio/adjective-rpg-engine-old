RSpec.describe "Statusable and Status integration" do
  before(:example) do
    @renew = SurrogateStatus.new("Renew", {affected_attributes: { hitpoints: 3}, max_duration: 5})
    @agony = SurrogateStatus.new("Agony", {affected_attributes: { hitpoints: -3}, max_duration: 10})
    @rend = SurrogateStatus.new("Rend", {affected_attributes: { hitpoints: -1}, max_duration: 3})

    # Actor has Adjective::Statusable included
    @actor = SurrogateActor.new("DefaultDude", {exp_table: [0,200,300,400,500,600,700,800,900,1000, 1200]})     
  end

  describe "#initialize_status_data" do 
    it "will set accessors for @statuses" do 
      expect(@rend.statuses).to eq([])
    end
  end

  describe "when utility methods are called" do 
    it "will correctly return instance variable signatures" do 
      expect(@agony.affected_attributes).to eq([:@hitpoints])
    end

    it "#has_status? will correctly check if a status is present" do
      @actor.apply_status(@rend)
      @actor.apply_status(@agony)
      expect(@actor.has_status?(:name, "Rend")).to eq(true)
      expect(@actor.has_status?(:name, "Agony")).to eq(true)
    end

    it "#has_status will correctly check if a status is NOT present" do
      @actor.apply_status(@rend)
      @actor.apply_status(@agony)
      expect(@actor.has_status?(:name, "Slow")).to eq(false)
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

  describe "when #tick_all is called" do 
    describe "when default functionality is used" do 
      it "will reduce the duration of each status by 1" do 
        @actor.apply_status(@renew)
        @actor.apply_status(@agony)
        @actor.apply_status(@rend)
        @actor.tick_all
        expect(@actor.statuses[0].remaining_duration).to eq(4)
        expect(@actor.statuses[1].remaining_duration).to eq(9)
        expect(@actor.statuses[2].remaining_duration).to eq(2)
      end
    end
  end

end