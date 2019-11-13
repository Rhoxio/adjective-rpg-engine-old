require 'spec_helper'

RSpec.describe Adjective::Actor do

  before(:example) do
    @default_actor = SurrogateActor.new("DefaultDude", {exp_table: [0,200,300,400,500,600,700,800,900,1000, 1200]}) 
    @custom_actor = SurrogateActor.new("CustomDude", {exp_table: [0,200,300,400,500,600,700,800,900,1000]}) 
    @s_actor = SurrogateActor.new("Surrogate", {exp_table: [0,200,300,400,500,600,700,800,900,1000]})
  end

  context "is namable" do 
    it "can set name" do
      # @default_actor.name = "Mike"
      expect(@default_actor.name).to eq("DefaultDude")
    end
  end

  context "when initialized with default parameters" do 
    it "has 1 hitpoint" do 
      expect(@default_actor.hitpoints).to eq(1)
    end

    it "is alive" do
      expect(@default_actor.alive?).to eq(true)
    end   

    it "is not dead" do 
      expect(@default_actor.dead?).to eq(false)
    end

    it "is level 1" do 
      expect(@default_actor.level).to eq(1)
    end 

    it "has default experience for given level" do
      expect(@default_actor.experience).to eq(200)
    end       
  end

  context "when statuses update" do 
    it "is dead if hitpoints are 0" do 
      @default_actor.hitpoints = 0
      expect(@default_actor.dead?).to eq(true)
    end

    it "is alive if hitpoints are > 1" do 
      @default_actor.hitpoints = 1
      expect(@default_actor.alive?).to eq(true)
    end
  end

  context "when damage is taken" do 
    it "will reduce hp" do
      # Checking if HP reduces at all.
      @default_actor.hitpoints = 10
      @default_actor.take_damage(5)
      expect(@default_actor.hitpoints).to be < 10
    end

    it "will reduce hp by specific value" do
      # Checking if the actual value and math is correct.
      @default_actor.hitpoints = 10
      @default_actor.take_damage(5)
      expect(@default_actor.hitpoints).to eq(5)
    end   

    it "does not drop below 0 hp" do 
      @default_actor.hitpoints = 10
      @default_actor.take_damage(20)
      expect(@default_actor.hitpoints).to eq(0)
    end

    it "takes no damage if 0 damage is dealt" do 
      @default_actor.hitpoints = 10
      @default_actor.take_damage(0)
      expect(@default_actor.hitpoints).to be == 10
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

  # context "when experience is lost" do 
  #   it "will properly remove experience" do 
  #     @default_actor.grant_experience(20)
  #     @default_actor.subtract_experience(10)
  #     expect(@default_actor.experience).to eq(10)
  #   end

  #   it "will not take negative numbers as an argument" do 
  #     @default_actor.grant_experience(20)
  #     expect{ @default_actor.subtract_experience(-10) }.to raise_error(RuntimeError)
  #   end

  #   it "will NOT remove levels if the suppress_levels option is passed" do 
  #     @default_actor.grant_experience(400)
  #     @default_actor.subtract_experience(300, {suppress_levels: true})
  #     expect(@default_actor.level).to eq(4)
  #   end       
  # end

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

  # context "when next level experience is checked" do 
  #   it "will give back the appropriate value" do 
  #     @default_actor.grant_experience(300)
  #     expect(@default_actor.experience_to_next_level).to eq(100)
  #   end

  #   it "will show 0 if character is max level" do
  #     @default_actor.grant_experience(1000)
  #     expect(@default_actor.level).to eq(9)
  #     p @default_actor.level
  #     p @default_actor.experience
  #     # expect(@default_actor.experience_to_next_level).to eq(0)
  #   end

  #   it "will throw a RangeError if attempting to access a level index not present in the actor's #exp_table" do 
  #     # @default_actor.level = 11
  #     # expect{ @default_actor.experience_to_next_level }.to raise_error(RangeError)
  #   end
  # end

  context "when stauses are applied through Statusable" do 
    it "will attain buff_stack and debuff_stack" do 
      expect(@custom_actor.instance_variable_get(:@buff_stack)).to eq([])
      expect(@custom_actor.instance_variable_get(:@debuff_stack)).to eq([])
    end

    it "sdjfsd" do 
      opts = { affected_attributes: [:hitpoints, :experience], duration: 10 }
      buff = Adjective::Buff.new("Renew", opts)
      @custom_actor.apply_buff(buff)
    end
  end

end









