RSpec.describe Adjective::Statusable do
  before(:example) do
    @renew = Adjective::Buff.new("Renew", { affected_attributes: :hitpoints })
    @agony = Adjective::Debuff.new("Agony", { duration: 12, affected_attributes: :hitpoints })
    @actor = SurrogateActor.new("DefaultDude", {exp_table: [0,200,300,400,500,600,700,800,900,1000, 1200]}) 
  end

  describe "when status initializes" do
    it "should throw a NotImplementedError if attempting to initialize superclass Status alone" do 
      expect{Adjective::Status.new("Surprise")}.to raise_error(NotImplementedError)
    end
  end

  describe "when utility methods are called" do 
    it "will accurately tell if the status is instant" do 
      expect(@renew.instant?).to eq(true)
      expect(@renew.over_time?).to eq(false)
    end

    it "will accurately tell if the status is over time" do 
      expect(@agony.over_time?).to eq(true)
      expect(@agony.instant?).to eq(false)
    end  

    it "will correctly convert instance variable signatures" do 
      expect(@agony.affected_attributes).to eq([:@hitpoints])
    end

  end

  describe "when buffs are handled" do 
    it "will add a buff to the @buff_stack" do 
      expect(@actor.apply_buff(@renew).length).to eq(1)
    end

    it "will add a debuff to the @debuff_stack" do 
      expect(@actor.apply_debuff(@agony).length).to eq(1)
    end  
  end
end