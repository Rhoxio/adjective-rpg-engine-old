RSpec.describe Table do

  before(:example) do
    @exp_table = Table::Experience.new('config/exp_table.yml', 'main')
  end

  context "when initialized" do

    it "loads yml file" do
      expect(@exp_table.data).to_not eq(nil)
    end

    it "throws RuntimeError if the file path is invalid" do 
      expect{ Table.new('config/bad_table.yml', 'invalid') }.to raise_error(RuntimeError)
    end

    it "can be initialized with a name" do 
      @table = Table.new('config/exp_table.yml', "main")
      expect(@table.name).to eq("main")
    end

    it "can be initialized without a name" do
      @table = Table.new('config/exp_table.yml')
      expect(@table.name).to eq(nil)
    end

  end

  it "can change names" do 
    @exp_table.name = "main2"
    expect(@exp_table.name).to eq("main2")
  end

end

RSpec.describe Table::Experience do

  before(:example) do
    @exp_table = Table::Experience.new('config/exp_table.yml', 'main')
  end

  context "when initialized" do 
    it "only allows sequential exp values" do 
      expect{ Table::Experience.new('config/exp_table.yml', 'wrong') }.to raise_error(RuntimeError)
    end

    it "sets thresholds" do 
      expect(@exp_table.thresholds).to_not be(nil)
    end

    it "continues if thresholds is an Array" do 
      expect(@exp_table.thresholds).to be_kind_of(Array)
    end

    it "throws an RuntimeError if thresholds is NOT an Array" do 
      expect{ Table::Experience.new('config/exp_table.yml', 'unseeded') }.to raise_error(RuntimeError)
    end
  end

  context "after initialization" do 
    context "at_level" do 
      it "responds correctly" do
        expect(@exp_table.at_level(0)).to eq(0)
        expect(@exp_table.at_level(1)).to eq(200)
        expect(@exp_table.at_level(-1)).to eq(1000)
      end

      it "does not accept common datatypes outside of Fixnum" do 
        expect{@exp_table.at_level("0")}.to raise_error(RuntimeError)
        expect{@exp_table.at_level([1])}.to raise_error(RuntimeError)
        expect{@exp_table.at_level({"1": 1})}.to raise_error(RuntimeError)
      end
    end

  end

end