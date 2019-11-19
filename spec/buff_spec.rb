RSpec.describe Adjective::Buff do

  before(:example) do
    opts = { affected_attributes: {hitpoints: 3}, duration: 10 }
    @single_attribute_opts = {affected_attributes: {hitpoints: 1 }}
    @buff = Adjective::Buff.new("Renew", opts)
  end

  describe "when buff initializes" do 
    it "will take in @attributes as an array" do 
      expect(@buff.affected_attributes).to eq([:@hitpoints])
    end

    it "will take a single symbol for @attributes" do 
      expect(Adjective::Buff.new("Renew", @single_attribute_opts).affected_attributes).to eq([:@hitpoints])
    end
  end

  describe "when utility methods are called" do 
    # it "will "
  end

  describe "when tick is called" do
    it "will tick" do 
      expect(@buff.tick).to eq(true)
    end

    it "will return false if it is expired upon ticking" do 
      expired_buff = Adjective::Buff.new("Renew", {affected_attributes: {duration: 10, remaining: 0}})
      expect(expired_buff.tick).to eq(false)
    end

    it "will accept a block" do 
      @buff.tick {|buff| buff.remaining -= 1}
      expect(@buff.duration).to eq(10)
      expect(@buff.remaining).to eq(9)
    end

    # it "will be a testing ground for me" do 
    #   actor = Adjective::Actor.new
    # end
  end

end