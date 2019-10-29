RSpec.describe Adjective::GlobalManager do

  before(:example) do
    @default_globals_file_path = 'config/globals.yml'
    @permanent_file_path = 'config/immortal_globals.yml'
    @default_keys = ["item_instance_ref", "actor_instance_ref", "inventory_instance_ref"]
    # File.open(@default_globals_file_path, "w"){}
  end

  context "when initialize is called" do 

    it "should initialize all Adjective globals" do 
      Adjective::GlobalManager.initialize
      expect($item_instance_ref).to eq(1)
      expect($actor_instance_ref).to eq(1)
      expect($inventory_instance_ref).to eq(1)
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
      Adjective::GlobalManager.increment_actors
      Adjective::GlobalManager.increment_inventories
      expect($item_instance_ref).to eq(2)
      expect($actor_instance_ref).to eq(2)
      expect($inventory_instance_ref).to eq(2)  
      Adjective::GlobalManager.increment_items
      Adjective::GlobalManager.increment_actors
      Adjective::GlobalManager.increment_inventories          
      expect($item_instance_ref).to eq(3)
      expect($actor_instance_ref).to eq(3)
      expect($inventory_instance_ref).to eq(3)        
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