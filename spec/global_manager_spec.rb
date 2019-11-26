RSpec.describe Adjective::GlobalManager do

  before(:example) do
    Adjective::GlobalManager.initialize
    @default_keys = ["item_instance_ref"]
  end

  context "when initialize is called" do 

    it "should initialize all Adjective globals" do 
      Adjective::GlobalManager.initialize
      expect($item_instance_ref).to eq(1)
    end

    context "when not loading" do 
      it "should set custom values if supplied" do 
        Adjective::GlobalManager.initialize do |settings|
          settings[:custom] = {
            key: 0,
            other_global: 0
          }
        end
        expect($key).to eq(0)
        expect($other_global).to eq(0)
      end
    end
  end  

  context "when Adjective-specific variables are incremented" do 
    it "will increment the correct references" do 
      Adjective::GlobalManager.initialize
      Adjective::GlobalManager.increment_items
      expect($item_instance_ref).to eq(2)
      Adjective::GlobalManager.increment_items         
      expect($item_instance_ref).to eq(3)        
    end
  end

  context "when custom variables are loaded through #load_globals" do 
    it "will accept and set the appropriate globals" do 
      Adjective::GlobalManager.load_globals({data: {max_entities: 1, inventory_reference: 2}})
      expect($max_entities).to eq(1)
      expect($inventory_reference).to eq(2)
    end

    it "will accept a block argument" do 
      Adjective::GlobalManager.load_globals({data: {max_entities: 1}}) do |globals|
        globals[:max_entities] = 5
      end
      expect($max_entities).to eq(5)
    end

    it "will override default adjective-specific globals" do 
      Adjective::GlobalManager.load_globals({data: {item_instance_ref: 2}})
      expect($item_instance_ref).to eq(2)      
    end
  end

  context "when asking for data about current variables" do 
    it "#get_globals returns the appropriate values" do 
      Adjective::GlobalManager.initialize
      globals = Adjective::GlobalManager.get_globals
      matches = globals.select {|k,v| @default_keys.include?(k) }
      expect(matches.length).to eq(@default_keys.length)
    end

    it "#keys will return all of the available keys" do 
      Adjective::GlobalManager.initialize
      expect(Adjective::GlobalManager.keys).to eq(@default_keys)
    end
  end

end