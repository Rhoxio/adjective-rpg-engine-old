RSpec.describe Adjective::Imbibable do
  before(:example) do
    # Level Key:
    #  0  1   2   3   4   5   6   7   8     9    10
    # [0,200,300,400,500,600,700,800,900, 1000, 1200]
    @default_actor = SurrogateActor.new("DefaultDude", {exp_table: [0,200,300,400,500,600,700,800,900,1000, 1200]}) 
  end

  context "when attributes are applied through Imbibable" do 
    it "will set and initialize @experience" do 
      expect(@default_actor.instance_variable_get(:@experience)).to eq(200)
    end

    it "will set and initialize @level" do 
      expect(@default_actor.instance_variable_get(:@level)).to eq(1)
    end    

    it "will set and initialize @experience" do 
      expect(@default_actor.instance_variable_get(:@active_exp_set)).to eq([0,200,300,400,500,600,700,800,900,1000, 1200])
    end    
  end

  context "when exp table is loaded" do 
    it "contains data" do 
      expect(@default_actor.active_exp_set).to_not eq(nil)
    end
  end

  context "when utility methods are called" do 
    it "correctly sets level minimum exp on init" do 
      expect(@default_actor.level).to eq(1)
      expect(@default_actor.experience).to eq(200)
    end

    it "correctly detects if it is below the threshold for level up" do 
      @default_actor.grant_experience(99)
      expect(@default_actor.can_level_up?).to eq(false)
    end      

    it "correctly levels up when single threshold is met" do 
      @default_actor.grant_experience(101)
      expect(@default_actor.level).to eq(2)
    end 

    it "correctly levels up when multiple thresholds are met" do 
      @default_actor.grant_experience(1000)
      expect(@default_actor.level).to eq(10)
    end 

    it "will not grant experience if they are max level" do 
      @default_actor.grant_experience(1000)
      expect(@default_actor.level).to eq(10)
      expect(@default_actor.grant_experience(1)).to eq(false)
      expect(@default_actor.experience).to eq(1200)
    end

    it "will not level up if :suppress_levels is passed" do 
      @default_actor.grant_experience(1000, {suppress_levels: true})
      expect(@default_actor.level).to eq(1)
    end

    it "will return the correct experience to next level" do 
      expect(@default_actor.experience_to_next_level).to eq(100)
      @default_actor.grant_experience(150)
      expect(@default_actor.experience_to_next_level).to eq(50)
      @default_actor.grant_experience(849)
      expect(@default_actor.experience_to_next_level).to eq(1)
      @default_actor.grant_experience(1)
      expect(@default_actor.experience_to_next_level).to eq(nil)
    end
  end

  context "when experience is gained" do 
    it "will properly grant experience" do 
      @default_actor.grant_experience(10)
      expect(@default_actor.experience).to eq(210)
    end   
  end


  context "when levels are granted" do 

    it "will grant multiple levels" do 
      @default_actor.grant_levels(3)
      expect(@default_actor.level).to eq(4)
    end

    it "will grant experience when granted levels" do 
      @default_actor.grant_levels(3)
      expect(@default_actor.level).to eq(4)
      expect(@default_actor.experience).to eq(500)
    end

    it "will NOT grant exp if constrain_exp option is passed" do 
      @default_actor.grant_levels(3, { constrain_exp: true })
      expect(@default_actor.level).to eq(4)
      expect(@default_actor.experience).to eq(200)
    end
  end

  context "when levels are set" do 
    it "will set the actor's level" do 
      @default_actor.set_level(5)
      expect(@default_actor.level).to eq(5)
    end

    it "correctly levels down when level set is lower than origin level" do 
      @default_actor.grant_experience(1000)
      @default_actor.set_level(2)
      expect(@default_actor.level).to eq(2)
      expect(@default_actor.experience).to eq(300)
    end    

    it "will set the actors experience in accordance with the level that was set" do 
      @default_actor.set_level(5)
      expect(@default_actor.level).to eq(5)
      expect(@default_actor.experience).to eq(600)
    end

    it "will NOT set the actor's experience if the constrain_exp option is passed" do 
      @default_actor.set_level(5, { constrain_exp: true })
      expect(@default_actor.level).to eq(5)
      expect(@default_actor.experience).to eq(200)
    end
  end  
end