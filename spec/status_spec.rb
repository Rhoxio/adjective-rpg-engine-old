RSpec.describe Adjective::Status do  
  before(:example) do 
    @renew = SurrogateStatus.new("Renew", {affected_attributes: { hitpoints: 3}, max_duration: 5})
    @agony = SurrogateStatus.new("Agony", {affected_attributes: { hitpoints: -3}, max_duration: 10})
    @rend = SurrogateStatus.new("Rend", {affected_attributes: { hitpoints: 1}})
    @cripple = SurrogateStatus.new("Cripple", {affected_attributes: { crit_multiplier: 1.0 }, max_duration: 5, tick_type: :static, reset_references: {crit_multiplier: :baseline_crit_multiplier} })
    @decay = SurrogateStatus.new("Decay", {affected_attributes: { hitpoints: -5 }, max_duration: 10, tick_type: :compounding, compounding_factor: Proc.new {|value, turn_mod| (value - turn_mod) * 1.5 }})
  end

  describe "when CRUD operations are performed" do
    it "correctly checks for modifier existence" do 
      expect(@renew.has_modifier?(:hitpoints)).to eq(true)
    end

    describe "when add_or_update_modifier is called" do 
      it "will update an existing modifier" do 
        @renew.add_or_update_modifier(:hitpoints, 10)
        expect(@renew.modifiers[:hitpoints]).to eq(10)
      end

      it "will add a nonexistent modifier" do 
        @renew.add_or_update_modifier(:speed, 2)
        expect(@renew.modifiers[:speed]).to eq(2)
      end

    end

    describe "when #assign_affected_attributes is called" do 
      it "will correctly pull from the keys in @modifiers" do 
        expect(@renew.affected_attributes).to eq([:@hitpoints])
      end
    end

    describe "when add_modifier is called" do 
      it "will update an existing modifier" do 
        @renew.add_modifier(:speed, 2)
        expect(@renew.modifiers[:speed]).to eq(2)
      end

      it "will not add an existing modifier" do 
        @renew.add_modifier(:hitpoints, 9)
        expect(@renew.modifiers[:hitpoints]).to eq(3)
      end   

      it "will return the full modifier list" do 
        @renew.add_modifier(:speed, 2)
        expect(@renew.modifiers).to eq({hitpoints: 3, speed: 2})
      end   
    end

    describe "when update_modifier is called" do
      it "will correctly update the modifier value" do  
        @renew.update_modifier(:hitpoints, 10)
        expect(@renew.modifiers[:hitpoints]).to eq(10)
      end

      it "will return the full and amended modifier list" do 
        @renew.update_modifier(:hitpoints, 9)
        expect(@renew.modifiers).to eq({hitpoints: 9})
      end         
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

    it "will return a hash with the amended tick_type specific values" do 
      output = @renew.tick
      expect(output).to be_a(Hash)
      expect(output.key?(:hitpoints)).to eq(true)
    end

    it "will correctly process :linear tick_types" do 
      output = @renew.tick
      expect(output[:hitpoints]).to eq(3)
    end

    it "will correctly process a :static tick_type" do 
      output = @cripple.tick
      expect(@cripple.remaining_duration).to eq(4)
      expect(output[:crit_multiplier]).to eq(1.0)
      empty_output = @cripple.tick
      expect(empty_output.empty?).to be(true)
    end

    it "will correctly process a :compounding tick_type" do 
      output = @decay.tick
      expect(output[:hitpoints]).to eq(-5)
      output = @decay.tick
      expect(output[:hitpoints]).to eq(-8)
      output = @decay.tick
      expect(output[:hitpoints]).to eq(-11)
    end
  end

end