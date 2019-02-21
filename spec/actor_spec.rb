require 'spec_helper'

RSpec.describe Actor do

  before(:example) do
    @exp_table = Table.new('config/exp_table.yml', 'main')
    @alt_exp_table = Table.new('config/exp_table.yml', "alt")

    @default_actor = Actor.new("", 
      { 
        exp_table: @exp_table, 
        exp_table_name: @exp_table.name 
      }
    ) 
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
      expect(@default_actor.exp_table).to_not eq(nil)
    end

    it "will default to 'main' table if no 'exp_table_name' option is passed" do
      expect(@default_actor.exp_table_name).to eq("main")
      expect(@default_actor.exp_table).to be_a_kind_of(Array)
    end

    it "will use a custom defined exp table if the 'exp_table_name' option is passed" do 
      @alt_actor = Actor.new("Altman the Testificate", { exp_table: @alt_exp_table, exp_table_name: @alt_exp_table.name }) 
      expect(@alt_actor.exp_table_name).to eq("alt")
      expect(@alt_actor.exp_table).to be_a_kind_of(Array)
    end

  end

end