RSpec.describe "Statusable and Status integration" do
  before(:example) do
    @renew = SurrogateStatus.new("Renew", {affected_attributes: { hitpoints: 3}, max_duration: 5})
    @agony = SurrogateStatus.new("Agony", {affected_attributes: { hitpoints: -3}, max_duration: 10})
    @rend = SurrogateStatus.new("Rend", {affected_attributes: { hitpoints: -1}, max_duration: 3})
    @toxic = SurrogateStatus.new("Toxic", {affected_attributes: { hitpoints: 5, badly_poisoned: true}, max_duration: 1})
    @cripple = SurrogateStatus.new("Cripple", {affected_attributes: { crit_multiplier: -0.5 }})

    @round = SurrogateStatusTwo.new("Round", {affected_attributes: {hitpoints: 3, fear: 4}, max_duration: 10 })
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
      @actor.apply_statuses([@rend, @agony])
      expect(@actor.has_status?(:name, "Rend")).to eq(true)
      expect(@actor.has_status?(:name, "Agony")).to eq(true)
    end

    it "#has_status will correctly check if a status is NOT present" do
      @actor.apply_statuses([@rend, @agony])
      expect(@actor.has_status?(:name, "Slow")).to eq(false)
    end

    it "will #sort_statuses! by remaining_duration by default" do 
      @actor.apply_statuses([@rend, @renew, @toxic])
      @actor.sort_statuses!
      expect(@actor.statuses.first.remaining_duration).to eq(1)
      expect(@actor.statuses.last.remaining_duration).to eq(5)
    end

    it "will #sort_statuses! by the provided attribute" do 
      @actor.apply_statuses([@rend, @toxic, @cripple])
      @actor.sort_statuses!(:name)
      expect(@actor.statuses.first.name).to eq("Cripple")
      expect(@actor.statuses.last.name).to eq("Toxic")
    end

    it "will #find_statuses that match the given attribute and value" do 
      @actor.apply_statuses([@rend, @agony, @cripple, @toxic])
      statuses = @actor.find_statuses(:remaining_duration, 3)
      expect(statuses.length).to eq(1)
      expect(statuses[0].name).to eq("Rend")
    end

    it "will #find_statuses that contain the given attribute ONLY" do 
      @actor.apply_statuses([@rend, @agony, @cripple, @toxic, @round])
      statuses = @actor.find_statuses(:effect)
      expect(statuses.length).to eq(1)
      expect(statuses[0].name).to eq("Round")
    end   

  end

  describe "when statuses are applied" do 
    it "will add a status to @statuses" do 
      expect(@actor.apply_statuses(@renew).length).to eq(1)
    end 

    it "will allow for a block argument" do 
      @actor.apply_statuses(@renew) do |model, statuses|
        expect(model.name).to eq("DefaultDude")
        expect(statuses[0].name).to eq("Renew")
      end
    end

    it "will allow an array of statuses to be applied" do 
      @actor.apply_statuses([@renew, @agony])
      expect(@actor.statuses.length).to eq(2)
      expect(@actor.statuses.first.name).to eq("Renew")
      expect(@actor.statuses.last.name).to eq("Agony")
    end 
  end

  describe "when #tick_all is called" do 
    describe "when default functionality is used" do 

      it "will strictly set NON-integer or float values with =" do 
        @actor.apply_statuses(@toxic)
        @actor.tick_all
        expect(@actor.badly_poisoned).to eq(true)
      end 

      it "will amend Float and Integer values with +=" do 
        @actor.heal_to_full
        @actor.apply_statuses(@rend)
        @actor.apply_statuses(@cripple)
        @actor.tick_all
        expect(@actor.hitpoints).to eq(9)
        expect(@actor.crit_multiplier).to eq(1.5)
      end

      it "will allow for a block argument to amend values" do 
        @actor.apply_statuses(@toxic) 
        @actor.tick_all do |actor, statuses|
          expect(@actor.badly_poisoned).to eq(true)
          actor.badly_poisoned = false
        end
        expect(@actor.badly_poisoned).to eq(false)
      end 

      it "will allow you to amend child statuses through a block" do 
        @actor.apply_statuses(@rend)
        @actor.tick_all do |actor, statuses|
          actor.statuses.each do |status|
            status.remaining_duration = status.max_duration
          end
        end
        expect(@actor.statuses[0].remaining_duration).to eq(3)
      end    
       
      it "will reduce the duration of each status by 1" do 
        @actor.apply_statuses([@renew, @agony, @rend])
        @actor.tick_all
        expect(@actor.statuses[0].remaining_duration).to eq(4)
        expect(@actor.statuses[1].remaining_duration).to eq(9)
        expect(@actor.statuses[2].remaining_duration).to eq(2)
      end
    end   
  end


end