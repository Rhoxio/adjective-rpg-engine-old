RSpec.describe Table do

  before(:example) do
    @exp_table = Table.new('config/exp_table.yml', 'main') 
  end

  context "when initialized" do 

    it "parses the yml file" do
      expect(@exp_table.data).to_not eq(nil)
    end

    it "throws RuntimeError if the file path is invalid" do 
      expect { Table.new('config/bad_table.yml', 'invalid') }.to raise_error(RuntimeError)
    end

    it "can be initialized with a name" do 
      @table = Table.new('config/exp_table.yml', "main")
      expect(@table.name).to eq("main")
    end

    it "can be initialized without a name" do
      @table = Table.new('config/exp_table.yml')
      expect(@table.name).to eq(nil)
    end

    it "can change names" do 
      @exp_table.name = "main2"
      expect(@exp_table.name).to eq("main2")
    end

  end

end