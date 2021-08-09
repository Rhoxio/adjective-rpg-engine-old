RSpec.describe Adjective::Temporable do
  before(:example) do 
    @renew_effect = Adjective::Modifier.new("RenewHealing", {hitpoints: 3})
    @agony_effect = Adjective::Modifier.new("AgonyEffect", {hitpoints: -3})
    @decay_effect = Adjective::Modifier.new("DecayEffect", {hitpoints: -5})
    @cripple_effect = Adjective::Modifier.new("CrippleEffect", { crit_multiplier: 1.0 })
    @malaise_effect = Adjective::Modifier.new("MalaiseEffect", { crit_multiplier: 1.0 })

    @renew = SurrogateStatus.new("Renew", { modifiers: [@renew_effect], max_duration: 5 })
    @agony = SurrogateStatus.new("Agony", {modifiers: [@agony_effect], max_duration: 10})    
    @cripple = SurrogateStatus.new("Cripple", {modifiers: [@cripple_effect], max_duration: 5, tick_type: :static, reset_references: {crit_multiplier: :baseline_crit_multiplier} })
    @decay = SurrogateStatus.new("Decay", {modifiers: [@decay_effect], max_duration: 10, tick_type: :compounding, compounding_factor: Proc.new {|value, turn_mod| (value - turn_mod) * 1.5 }})
    
    @malaise = SurrogateStatus.new("Malaise", {modifiers: [@malaise_effect], indefinite: true})
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