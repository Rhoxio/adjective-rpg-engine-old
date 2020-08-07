RSpec.describe Adjective::Applicable do 

  before(:example) do
    @renew = SurrogateStatus.new("Renew", {modifiers: { hitpoints: 3}, max_duration: 5})
  end

  describe "when initialized" do
    it "will correctly initialize with modifiers" do
      expect(@renew.modifiers).to eq({ hitpoints: 3})
    end
  end
  
  describe "when CRUD operations are performed" do
    it "correctly checks for modifier existence" do 
      expect(@renew.has_modifier?(:hitpoints)).to eq(true)
    end

    describe "when add_or_update_modifier is called" do 
      it "will update an existing modifier" do 
        @renew.add_or_update_modifier(:hitpoints, 10)
        expect(@renew.modifiers[:hitpoints]).to eq(10)
      end

      it "will add a nonexistent modifier" do 
        @renew.add_or_update_modifier(:speed, 2)
        expect(@renew.modifiers[:speed]).to eq(2)
      end

    end

    describe "when add_modifier is called" do 
      it "will update an existing modifier" do 
        @renew.add_modifier(:speed, 2)
        expect(@renew.modifiers[:speed]).to eq(2)
      end

      it "will not add an existing modifier" do 
        @renew.add_modifier(:hitpoints, 9)
        expect(@renew.modifiers[:hitpoints]).to eq(3)
      end   

      it "will return the full modifier list" do 
        @renew.add_modifier(:speed, 2)
        expect(@renew.modifiers).to eq({hitpoints: 3, speed: 2})
      end   
    end

    describe "when update_modifier is called" do
      it "will correctly update the modifier value" do  
        @renew.update_modifier(:hitpoints, 10)
        expect(@renew.modifiers[:hitpoints]).to eq(10)
      end

      it "will return the full and amended modifier list" do 
        @renew.update_modifier(:hitpoints, 9)
        expect(@renew.modifiers).to eq({hitpoints: 9})
      end         
    end
  end  
end