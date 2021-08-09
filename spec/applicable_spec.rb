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

      it "will amend a modifier if the names line up" do 
        mod = @renew.add_or_update_modifier("RenewHealing", :hitpoints, 1)
        expect(mod.affected_attributes[:hitpoints]).to eq(1)
      end
    end
      

  end

  # describe "when initialized" do
  #   it "will correctly initialize with modifiers" do
  #     expect(@renew.modifiers).to eq({ hitpoints: 3})
  #   end
  # end
  
  # describe "when CRUD operations are performed" do
  #   it "correctly checks for modifier existence" do 
  #     expect(@renew.has_modifier?(:hitpoints)).to eq(true)
  #   end

  #   describe "when add_or_update_modifier is called" do 
  #     it "will update an existing modifier" do 
  #       @renew.add_or_update_modifier(:hitpoints, 10)
  #       expect(@renew.modifiers[:hitpoints]).to eq(10)
  #     end

  #     it "will add a nonexistent modifier" do 
  #       @renew.add_or_update_modifier(:speed, 2)
  #       expect(@renew.modifiers[:speed]).to eq(2)
  #     end

  #   end

  #   describe "when add_modifier is called" do 
  #     it "will update an existing modifier" do 
  #       @renew.add_modifier(:speed, 2)
  #       expect(@renew.modifiers[:speed]).to eq(2)
  #     end

  #     it "will not add an existing modifier" do 
  #       @renew.add_modifier(:hitpoints, 9)
  #       expect(@renew.modifiers[:hitpoints]).to eq(3)
  #     end   

  #     it "will return the full modifier list" do 
  #       @renew.add_modifier(:speed, 2)
  #       expect(@renew.modifiers).to eq({hitpoints: 3, speed: 2})
  #     end   
  #   end

  #   describe "when update_modifier is called" do
  #     it "will correctly update the modifier value" do  
  #       @renew.update_modifier(:hitpoints, 10)
  #       expect(@renew.modifiers[:hitpoints]).to eq(10)
  #     end

  #     it "will return the full and amended modifier list" do 
  #       @renew.update_modifier(:hitpoints, 9)
  #       expect(@renew.modifiers).to eq({hitpoints: 9})
  #     end         
  #   end
  # end  
end