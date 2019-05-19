require 'spec_helper'

RSpec.describe Actor do

  before(:example) do
    @exp_table = Table::Experience.new('config/exp_table.yml', 'main')
    @alt_exp_table = Table::Experience.new('config/exp_table.yml', "alt")

    @default_actor = Actor.new("", 
      { 
        exp_sets: @exp_table, 
        exp_set_name: @exp_table.name 
      }
    ) 
    @custom_actor = Actor.new("", { exp_sets: @exp_table, exp_set_name: @exp_table.name, mana: 100 }) 
  end

  context "is namable" do 
    it "can set name" do
      @default_actor.name = "Mike"
      expect(@default_actor.name).to eq("Mike")
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

    it "has 0 experience" do
      expect(@default_actor.experience).to eq(0)
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

    it "will default to 'main' table if no 'exp_table_name' option is passed" do
      expect(@default_actor.exp_set_name).to eq("main")
      expect(@default_actor.active_exp_set).to be_a_kind_of(Array)
    end

    it "will use a custom defined exp table if the 'exp_table_name' option is passed" do 
      @alt_actor = Actor.new("Altman the Testificate", { exp_sets: @alt_exp_table, exp_set_name: @alt_exp_table.name }) 
      expect(@alt_actor.exp_set_name).to eq("alt")
      expect(@alt_actor.active_exp_set).to be_a_kind_of(Array)
    end

  end

  context "when experience is gained" do 
    it "will properly grant experience" do 
      @default_actor.grant_experience(10)
      expect(@default_actor.experience).to eq(10)
    end

    it "can level up if experience is exactly threshold value" do 
      @default_actor.grant_experience(200)
      expect(@default_actor.level).to eq(2)
      expect(@default_actor.can_level_up?).to eq(false)
    end

    it "can level up if experience is above threshold value" do 
      @default_actor.grant_experience(301)
      expect(@default_actor.level).to eq(3)
      expect(@default_actor.can_level_up?).to eq(false)
    end    

    it "can NOT level up if experience is below threshold value" do 
      @default_actor.grant_experience(199)
      expect(@default_actor.level).to eq(1)
      expect(@default_actor.can_level_up?).to eq(false)
    end 

    it "will not take negative numbers as an argument" do 
      @default_actor.experience = 20
      expect{ @default_actor.grant_experience(-10) }.to raise_error(RuntimeError)
    end

    it "will NOT grant levels if the suppress_levels option is passed" do 
      @default_actor.grant_experience(400, {suppress_levels: true})
      expect(@default_actor.level).to eq(1)
    end    

  end

  context "when experience is lost" do 
    it "will properly remove experience" do 
      @default_actor.experience = 20
      @default_actor.subtract_experience(10)
      expect(@default_actor.experience).to eq(10)
    end

    it "will not take negative numbers as an argument" do 
      @default_actor.experience = 20
      expect{ @default_actor.subtract_experience(-10) }.to raise_error(RuntimeError)
    end

    it "will NOT remove levels if the suppress_levels option is passed" do 
      @default_actor.grant_experience(400)
      @default_actor.subtract_experience(300, {suppress_levels: true})
      expect(@default_actor.level).to eq(4)
    end       
  end

  context "when levels are awarded" do 
    it "will grant levels until corret threshold is met" do 
      @default_actor.grant_experience(200)
      expect(@default_actor.level_up!).to eq(false)
      expect(@default_actor.level).to eq(2)
    end  

    it "will NOT grant a level if can_level_up? does not pass" do
      @default_actor.grant_experience(199)
      expect(@default_actor.level_up!).to eq(false)
      expect(@default_actor.level).to eq(1)
    end

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
      expect(@default_actor.experience).to eq(0)
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
      expect(@default_actor.experience).to eq(0)
    end
  end

  context "when next level experience is checked" do 
    it "will give back the appropriate value" do 
      @default_actor.grant_experience(300)
      expect(@default_actor.experience_to_next_level).to eq(100)
    end

    it "will show 0 if character is max level" do 
      @default_actor.level = 10
      expect(@default_actor.experience_to_next_level).to eq(0)
    end

    it "will throw a RangeError if attempting to access a level index not present in the actor's #exp_table" do 
      @default_actor.level = 11
      expect{ @default_actor.experience_to_next_level }.to raise_error(RangeError)
    end
  end

  context "when experience table sets are swapped" do 
    it "will swap to the correct set within its original table" do 
      @default_actor.use_experience_set("alt")
      expect(@default_actor.exp_set_name).to eq("alt")
    end
  end

  context "when additional data parameters are passed" do 
    it "will reply with the intended value when called" do 
      expect(@custom_actor.mana).to eq(100)
    end

    it "will allow for a custom value to be set after initialization" do 
      @custom_actor.mana = 200
      @custom_actor.mana
      expect(@custom_actor.mana).to eq(200) 
    end
  end

  context "when additional attributes are added after initialization" do 

    it "will add the appropriate attribute" do
      @custom_actor.add_attribute("energy", 120)
      expect(@custom_actor.energy).to eq(120)
    end

    it "will set the appropriate attribute" do 
      @custom_actor.add_attribute("energy", 120)
      @custom_actor.energy = 150
      expect(@custom_actor.energy).to eq(150)
    end

    it "will not allow two of the same attribute names" do
      @custom_actor.add_attribute("energy", 120)
      expect{@custom_actor.add_attribute("energy", 130)}.to raise_error(RuntimeError)
    end
  end

  context "when additional attributes are removed after initialization" do 
    it "will remove the getter method" do 
      @custom_actor.add_attribute("energy", 120)
      @custom_actor.remove_attribute(:energy)
      expect{@custom_actor.energy}.to raise_error(NoMethodError)
    end

    it "will remove the setter method" do 
      @custom_actor.add_attribute("energy", 120)
      @custom_actor.remove_attribute(:energy)
      expect{@custom_actor.energy = 100}.to raise_error(NoMethodError)
    end

    it "will will remove the instance variable" do
      @custom_actor.add_attribute("energy", 120)
      @custom_actor.remove_attribute(:energy)
      expect(@custom_actor.instance_variable_defined?("@energy")).to be(false)
    end

    it "will error out if attempting to remove a nonexistent attribute" do 
      expect{@custom_actor.remove_attribute(:xyt)}.to raise_error(RuntimeError)
    end

  end

end









