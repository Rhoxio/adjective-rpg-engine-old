require 'spec_helper'

RSpec.describe Adjective::Vulnerable do

  before(:example) do
    @default_actor = SurrogateActor.new("DefaultDude", {exp_table: [0,200,300,400,500,600,700,800,900,1000, 1200]}) 
    @custom_actor = SurrogateActor.new("CustomDude", {exp_table: [0,200,300,400,500,600,700,800,900,1000]}) 
    @s_actor = SurrogateActor.new("Surrogate", {exp_table: [0,200,300,400,500,600,700,800,900,1000]})
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
     
  end

  context "when statuses update" do 
    it "is dead if hitpoints are 0" do 
      @default_actor.take_damage(1000)
      expect(@default_actor.dead?).to eq(true)
       expect(@default_actor.hitpoints).to eq(0)
    end

    it "is alive if hitpoints are > 1" do 
      expect(@default_actor.alive?).to eq(true)
    end
  end

  context "when damage is taken" do 
    it "will reduce hp" do
      @default_actor.heal_to_full
      @default_actor.take_damage(5)
      expect(@default_actor.hitpoints).to be < 10
    end

    it "will reduce hp by specific value" do
      @default_actor.heal_to_full
      @default_actor.take_damage(5)
      expect(@default_actor.hitpoints).to eq(5)
    end   

    it "does not drop below 0 hp" do 
      @default_actor.heal_to_full
      @default_actor.take_damage(20)
      expect(@default_actor.hitpoints).to eq(0)
    end

    it "takes no damage if 0 damage is dealt" do 
      @default_actor.heal_to_full
      @default_actor.take_damage(0)
      expect(@default_actor.hitpoints).to be == 10
    end 

  end

  context "when fully healed" do 
    it "will set hitpoints to the maximum" do 
      @default_actor.heal_to_full
      expect(@default_actor.hitpoints).to eq(10)
    end
  end

  context "when healed" do 
    it "will not heal above your max hp" do 
      @default_actor.heal_for(1000)
      expect(@default_actor.hitpoints).to eq(10)
    end
  end

  context "when max_hitpoints are set" do 
    it "will allow for them to be set to any value" do 
      @default_actor.max_hitpoints = 100
      expect(@default_actor.max_hitpoints).to eq(100)
      expect(@default_actor.hitpoints).to eq(1)
    end
  end

end









