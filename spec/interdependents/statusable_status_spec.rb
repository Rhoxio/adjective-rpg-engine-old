RSpec.describe "Statusable and Status integration" do
  before(:example) do
    @renew = SurrogateStatus.new("Renew", {modifiers: { hitpoints: 3}, max_duration: 5, tick_type: :linear})
    @agony = SurrogateStatus.new("Agony", {modifiers: { hitpoints: -3}, max_duration: 10, tick_type: :linear})
    @rend = SurrogateStatus.new("Rend", {modifiers: { hitpoints: -1}, max_duration: 3, tick_type: :linear})
    @toxic = SurrogateStatus.new("Toxic", {modifiers: { hitpoints: -5}, max_duration: 1, tick_type: :compounding})
    @cripple = SurrogateStatus.new("Cripple", {modifiers: { crit_multiplier: 1.0 }, max_duration: 5, tick_type: :static, reset_references: {crit_multiplier: :baseline_crit_multiplier} })
    @decay = SurrogateStatus.new("Decay", {modifiers: { hitpoints: -1 }, max_duration: 5, tick_type: :compounding, compounding_factor: Proc.new {|value, turns| value * 2}})
    @round = SurrogateStatusTwo.new("Round", {modifiers: {hitpoints: 3, fear: 4}, max_duration: 10, tick_type: :static }, "Description")
    @twiddle = SurrogateStatusTwo.new("Twiddle", {modifiers: {hitpoints: 3, fear: 6}, max_duration: 12, tick_type: :static }, "A magic spell")
    # Actor has Adjective::Statusable included
    @actor = SurrogateActor.new("DefaultDude", {exp_table: [0,200,300,400,500,600,700,800,900,1000, 1200]})     
  end

  describe "#initialize_status_data" do 
    it "will set accessors for @statuses" do 
      expect(@rend.statuses).to eq([])
    end
  end

  describe "when utility methods are called" do 

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

    it "will append statuses that do not respond to the given method to the end" do 
      @actor.apply_statuses([@rend, @toxic, @cripple, @round, @twiddle])
      @actor.sort_statuses!(:description)
      expect(@actor.statuses[0].name).to eq("Twiddle")
      expect(@actor.statuses[1].name).to eq("Round")
      expect(@actor.statuses[2..-1].map{|s| s.name}).to eq(["Rend", "Toxic", "Cripple"])
    end

    it "will #find_statuses (plural) that match the given attribute and value" do 
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

    it "will #find_status (singular) and return the first matching" do
      @actor.apply_statuses([@rend, @agony, @cripple, @toxic, @round])
      cripple = @actor.find_status(:name, "Cripple")
      expect(cripple.name).to eq("Cripple")
    end

  end

  describe "when statuses are applied" do 
    it "will add a status to @statuses" do 
      expect(@actor.apply_statuses(@renew).length).to eq(1)
      expect(@actor.statuses.length).to eq(1)
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

  describe "when statuses are removed" do 
    it "will remove the correct statuses" do 
      @actor.apply_statuses([@renew, @agony, @rend])
      removed = @actor.remove_statuses(:name, "Rend")
      expect(removed[0].name).to eq("Rend")
      expect(@actor.has_status?(:name, "Rend")).to eq(false)
      expect(@actor.statuses.length).to eq(2)
    end

    it "will remove statuses by given attribute and matching value" do
      rend2 = @rend.dup
      rend3 = @rend.dup
      @actor.apply_statuses([@rend, rend2, rend3])
      @actor.statuses[0].remaining_duration = 1
      expect(@actor.statuses[0].remaining_duration).to eq(1)
      removed = @actor.remove_statuses(:remaining_duration, 1)
      expect(removed.length).to eq(1)
      expect(@actor.has_status?(:name, "Rend")).to eq(true)
      expect(@actor.statuses.length).to eq(2)
    end

    it "will remove a single status with #remove_status" do
      agony2 = @agony.dup
      agony3 = @agony.dup 
      @actor.apply_statuses([@agony, agony2, agony3])
      @actor.remove_status(:name, "Agony")
      expect(@actor.statuses.length).to eq(2)
    end

    it "will remove expired statuses with #clear_expired_statuses!" do 
      @actor.apply_statuses([@renew, @agony, @rend])
      10.times {@actor.tick_all}
      @actor.clear_expired_statuses!
      expect(@actor.statuses.length).to eq(0)
    end
  end

  describe "when #tick_all is called" do 

    describe "when a block argument is used" do 
      it "will allow for a block argument to amend values" do 
        @actor.apply_statuses(@toxic) 
        @actor.tick_all do |actor, statuses|
          expect(@actor.badly_poisoned).to eq(false)
          # Emulating what might happen in this block...
          actor.find_statuses(:name, "Toxic")[0].remaining_duration -= 1
          actor.badly_poisoned = true
        end
        expect(@actor.badly_poisoned).to eq(true)
        expect(@actor.find_statuses(:name, "Toxic").length).to eq(0)
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
    end

    describe "when default functionality is used" do 

      it "will correctly amend parent class against :compounding status types" do 
        @actor.heal_to_full
        @actor.apply_statuses(@decay)
        @actor.tick_all
        expect(@actor.hitpoints).to eq(9)
        @actor.tick_all
        expect(@actor.hitpoints).to eq(7)
        @actor.tick_all
        expect(@actor.hitpoints).to eq(3)
        @actor.tick_all
        @actor.normalize_hitpoints
        expect(@actor.dead?).to eq(true)
      end

      it "will correctly amend parent class against :linear status types" do 
        @actor.heal_to_full
        @actor.apply_statuses(@agony)
        @actor.tick_all
        expect(@actor.hitpoints).to eq(7)
        @actor.tick_all
        expect(@actor.hitpoints).to eq(4)
        @actor.tick_all
        expect(@actor.hitpoints).to eq(1)        
      end

      it "will correctly reset the parent class after a :static status expires" do 
        @actor.apply_statuses(@cripple)
        @actor.tick_all
        expect(@actor.crit_multiplier).to eq(1.0)
        4.times { @actor.tick_all }
        expect(@actor.crit_multiplier).to eq(2.0)
      end

      it "will correctly amend parent class against :static status types" do 
        @actor.apply_statuses(@cripple)
        expect(@actor.crit_multiplier).to eq(2.0)
        @actor.tick_all
        expect(@actor.crit_multiplier).to eq(1.0)
      end

    end

    describe "when a proc is passed" do 
      it "will allow you to access and amend statuses through a proc" do 
        @actor.apply_statuses(@cripple)
        s_proc = Proc.new do |status| 
          if status.name == "Cripple"
            # Will persist forever if some outside condition is met, for example.
            status.remaining_duration = status.max_duration
          end
        end
        @actor.tick_all(s_proc)
        expect(@actor.find_status(:name, "Cripple").remaining_duration).to eq(5)
      end

      it "will correctly process default functionality of #tick_all for :linear" do
        @actor.heal_to_full
        @actor.apply_statuses([@rend])
        status_proc = Proc.new do |status, output|
          output[:hitpoints] = (status.modifiers[:hitpoints] - 3) if status.name == "Rend"
        end
        @actor.tick_all(status_proc)
        expect(@actor.hitpoints).to eq(6)
      end

      it "will correctly process default functionality of #tick_all for :static" do 
        @actor.heal_to_full
        @actor.apply_statuses([@cripple])
        @actor.tick_all
        expect(@actor.crit_multiplier).to eq(1.0)
        status_proc = Proc.new do |status, output|
          if status.name == "Cripple"
            output[:crit_multiplier] = 2.5
          end
        end
        @actor.tick_all(status_proc)
        expect(@actor.crit_multiplier).to eq(2.5)
        3.times {@actor.tick_all}
        expect(@actor.crit_multiplier).to eq(2.0)
      end

      it "will correctly process default functionality of #tick_all for :compounding" do 
        @actor.heal_to_full
        @actor.apply_statuses([@decay])
        status_proc = Proc.new do |status, output|
          output[:hitpoints] = -5 if status.name == "Decay"
        end
        @actor.tick_all(status_proc)
        expect(@actor.hitpoints).to eq(5)
      end
    end

  end


end