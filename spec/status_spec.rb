RSpec.describe Adjective::Status do  
  before(:example) do
    @renew_modifier = Adjective::Modifier.new("RenewHealing", {hitpoints: 3})
    @empowered_renew_effect = Adjective::Modifier.new("RenewHealing", {hitpoints: 5})

    @agony_effect = Adjective::Modifier.new("AgonyEffect", {hitpoints: -3})

    @decay_effect = Adjective::Modifier.new("DecayEffect", {hitpoints: -5})
    @empowered_decay_effect = Adjective::Modifier.new("DecayEffect", {hitpoints: -2})

    @cripple_effect = Adjective::Modifier.new("CrippleEffect", { crit_multiplier: 1.0 })

    @renew = SurrogateStatus.new("Renew", { modifiers: [@renew_modifier], max_duration: 5 })
    @agony = SurrogateStatus.new("Agony", {modifiers: [@agony_effect], max_duration: 10})    
    @cripple = SurrogateStatus.new("Cripple", {modifiers: [@cripple_effect], max_duration: 5, tick_type: :static, reset_references: {crit_multiplier: :baseline_crit_multiplier} })
    @decay = SurrogateStatus.new("Decay", {modifiers: [@decay_effect], max_duration: 10, tick_type: :compounding, compounding_factor: Proc.new {|value, turn_mod| (value - turn_mod) * 1.5 }})
    
    @empowered_renew = SurrogateStatus.new("Renew", { modifiers: [@renew_modifier, @empowered_renew_effect], max_duration: 5 })
    @empowered_decay = SurrogateStatus.new("Empowered Decay", {modifiers: [@decay_effect, @empowered_decay_effect], max_duration: 10, tick_type: :compounding, compounding_factor: Proc.new {|value, turn_mod| (value - turn_mod) * 1.5 }})    
  end

  describe "when tick is called" do 
    it "will reduce the @remaining_duration by default" do 
      @renew.tick
      expect(@renew.remaining_duration).to eq(4)
    end

    it "will allow for a block" do 
      @renew.tick do |status|
        expect(status.modifiers.length > 0).to eq(true)
        {status: status}
      end
    end

    it "will allow for attributes to be amended in block" do 
      @renew.tick do |status|
        status.max_duration = 10
        status.remaining_duration = 8
        {status: status}
      end
      expect(@renew.max_duration).to eq(10)
      expect(@renew.remaining_duration).to eq(8)
    end

    it "will return a hash with the amended tick_type specific values" do 
      output = @renew.tick
      expect(output).to be_a(Hash)
      expect(output.key?("RenewHealing")).to eq(true)
    end


    it "will correctly process :linear tick_types" do 
      output = @renew.tick
      expect(output["RenewHealing"][:hitpoints]).to eq(3)
    end

    it "will correctly process a :static tick_type" do 
      output = @cripple.tick
      expect(@cripple.remaining_duration).to eq(4)
      expect(output["CrippleEffect"][:crit_multiplier]).to eq(1.0)
      empty_output = @cripple.tick
      expect(empty_output.length).to eq(1)
    end

    it "will correctly process a :compounding tick_type" do 
      output = @decay.tick
      expect(output["DecayEffect"][:hitpoints]).to eq(-5)
      output = @decay.tick
      expect(output["DecayEffect"][:hitpoints]).to eq(-8)
      output = @decay.tick
      expect(output["DecayEffect"][:hitpoints]).to eq(-11)
    end

    it "will take a block and still allow for status_proc to be used" do 
      status_proc = Proc.new do |status, output|
        output["PainEffect"] = {pain: -2}
      end
      output = @decay.tick(status_proc) do |status|
        mod = status.add_modifier("PainEffect", :pain, -4)
        expect(status.has_modifier?("PainEffect")).to eq(true)
        {status: status}
      end
      expect(output["PainEffect"][:pain]).to eq(-2)
      expect(output.key?("DecayEffect")).to eq(false)
    end

    it "will give back a :source by default" do 
      output = @decay.tick
      expect(output[:source].name).to eq("Decay")
    end

    it "will assign :source if not present if block is given" do 
      output = @decay.tick {|status| {status: status} }
      expect(output[:source].name).to eq("Decay")
    end

    it "will allow for the combination of keys that share the same effect" do 
      expect(@empowered_renew.tick["RenewHealing"][:hitpoints]).to eq(8)
    end

    it "will allow for the combination of keys that share the same effect while compounding" do 
      expect(@empowered_decay.tick["DecayEffect"][:hitpoints]).to eq(-7)
      expect(@empowered_decay.tick["DecayEffect"][:hitpoints]).to eq(-11)
      expect(@empowered_decay.tick["DecayEffect"][:hitpoints]).to eq(-17)
      expect(@empowered_decay.tick["DecayEffect"][:hitpoints]).to eq(-23)

    end
  end

end