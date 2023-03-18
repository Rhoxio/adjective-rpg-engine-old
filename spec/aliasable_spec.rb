require 'spec_helper'

RSpec.describe Adjective::Aliasable do

  before(:example) do
    @given_aliases = {
      :hp => :hitpoints,
      :max_hp => :max_hitpoints
    }    
    @flexible_class = SurrogateFlexible.new(@given_aliases)
  end

  describe "interactions with adjective libs" do 

  end

  describe "aliasable initialization" do 
    it "will allow for current attributes to be aliased in" do 
      # This includes Vulnerable for testing purposes.
      expect(SurrogateFlexible.new(@given_aliases).hitpoints).to eq(1)
    end

    it "will not allow for Adjective attributes that are not present on initialization" do 
      bad_aliases = {
        :hp => :hitpoints,
        :max_hp => :max_badstuff
      }          
      expect{SurrogateFlexible.new(bad_aliases)}.to raise_error(NoMethodError)
    end

    it "will not allow for custom attributes that are not present on initialization" do 
      bad_aliases = {
        :hp => :hitpoints,
        :max_hp => :max_hitpoints,
        :label => :dog
      }          
      expect{SurrogateFlexible.new(bad_aliases)}.to raise_error(NoMethodError)
    end
  end

  describe "process_aliases" do 
    it "will sandbox for me" do 
      ap @flexible_class.__adj_new_aliases
    end
  end
end