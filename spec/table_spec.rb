RSpec.describe Adjective::Table do

  before(:example) do
    @exp_table = Adjective::Table::Experience.new('config/exp_table.yml', 'main')
  end

  context "when initialized" do

    it "loads yml file" do
      expect(@exp_table.data).to_not eq(nil)
    end

    it "throws RuntimeError if the file path is invalid" do 
      expect{ Adjective::Table.new('config/bad_table.yml', 'invalid') }.to raise_error(RuntimeError)
    end

    it "can be initialized with a name" do 
      @table = Adjective::Table.new('config/exp_table.yml', "main")
      expect(@table.name).to eq("main")
    end

    it "can be initialized without a name" do
      @table = Adjective::Table.new('config/exp_table.yml')
      expect(@table.name).to eq(nil)
    end

  end

  it "can change names" do 
    @exp_table.name = "main2"
    expect(@exp_table.name).to eq("main2")
  end

end

RSpec.describe Adjective::Table::Experience do

  before(:example) do
    @exp_table = Adjective::Table::Experience.new('config/exp_table.yml', 'main')
  end

  context "when initialized" do 
    it "only allows sequential exp values" do 
      expect{ Adjective::Table::Experience.new('config/exp_table.yml', 'wrong') }.to raise_error(RuntimeError)
    end

    it "sets thresholds" do 
      expect(@exp_table.thresholds).to_not be(nil)
    end

    it "continues if thresholds is an Array" do 
      expect(@exp_table.thresholds).to be_kind_of(Array)
    end

    it "throws a RuntimeError if thresholds is NOT an Array" do 
      expect{ Adjective::Table::Experience.new('config/exp_table.yml', 'unseeded') }.to raise_error(RuntimeError)
    end
  end

  context "when asked to validate the existence of a set" do 
    it "should return true if the named set exists" do 
      expect(@exp_table.set_exists?("main")).to eq(true)
    end

    it "should return false if the named set does not exist" do 
      expect(@exp_table.set_exists?("laik")).to eq(false)
    end
  end

  context "after initialization" do 
    context "at_level" do 
      it "responds correctly" do
        expect(@exp_table.at_level(0)).to eq(0)
        expect(@exp_table.at_level(1)).to eq(200)
        expect(@exp_table.at_level(-1)).to eq(1000)
      end

      it "does not accept datatypes outside of Fixnum" do 
        expect{@exp_table.at_level("0")}.to raise_error(RuntimeError)
        expect{@exp_table.at_level([1])}.to raise_error(RuntimeError)
        expect{@exp_table.at_level({"1": 1})}.to raise_error(RuntimeError)
        expect{@exp_table.at_level(nil)}.to raise_error(RuntimeError)
      end
    end

  end

end