RSpec.describe Adjective::Applicable do 

  before(:each) do
    @modifier = Adjective::Modifier.new("RenewHealing", {hitpoints: 3})
    @stat_boost = Adjective::Modifier.new("RenewBuff", {hitpoints: 1})
    @renew = SurrogateStatus.new("Renew", { modifiers: [@modifier, @stat_boost], max_duration: 5 })
  end

  describe "will sandbox for me" do 
    it "will run" do 
      # ap @renew.modifiers
    end
  end

  describe "CRUD actions" do 
    it "will find the approriate modifier" do 
      @renew.has_modifier?("RenewHealing")
    end

    it "will select the approriate modifier" do 
      expect(@renew.find_modifier("RenewHealing")).to eq(@modifier)
    end

    it "will return false if no modifiers are found" do 
      expect(@renew.find_modifier("Bunk")).to eq(false)
    end

    context "when add_or_update_modifier is called" do 
      it "will add new if modifier doesnt exist" do 
        @renew.add_or_update_modifier("BonusHitpoints", :hitpoints, 1)
        expect(@renew.has_modifier?("BonusHitpoints")).to eq(true)
        expect(@renew.modifiers.length).to eq(3)
      end

      it "will update a modifier" do 
        mod = @renew.add_or_update_modifier("RenewHealing", :hitpoints, 1)
        expect(mod.affected_attributes[:hitpoints]).to eq(1)
      end
    end

    context "when update_modifier is called" do 
      it "will update the modifier" do 
        mod = @renew.update_modifier("RenewHealing", :hitpoints, 1)
        expect(mod.affected_attributes[:hitpoints]).to eq(1)
      end
    end
      
    context "when update_modifier is called" do 
      it "will add the modifier" do 
        @renew.add_or_update_modifier("BonusHitpoints", :hitpoints, 1)
        expect(@renew.has_modifier?("BonusHitpoints")).to eq(true)
        expect(@renew.modifiers.length).to eq(3)        
      end
    end

    context "when modifier is removed" do 
      it "will remove the modifier" do 
        removed_modifier = @renew.remove_modifier("RenewHealing")
        expect(removed_modifier).to eq(@modifier)
      end
    end

  end 
end