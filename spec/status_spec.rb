RSpec.describe Adjective::Status do
  before(:example) do
    @renew = Adjective::Buff.new("Renew")
    @agony = Adjective::Debuff.new("Agony", {duration: 12})
  end

  describe "when status initializes" do
    it "should throw a NotImplementedError if attempting to initialize superclass Status alone" do 
      expect{Adjective::Status.new("Surprise")}.to raise_error(NotImplementedError)
    end
  end

  describe "when utlity methods are called" do 
    it "will accurately tell if the status is instant" do 
      expect(@renew.instant?).to eq(true)
      expect(@renew.over_time?).to eq(false)
    end

    it "will accurately tell if the status is over time" do 
      expect(@agony.over_time?).to eq(true)
      expect(@agony.instant?).to eq(false)
    end

  end
end