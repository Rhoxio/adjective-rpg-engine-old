RSpec.describe Adjective::GlobalManager do

  before(:example) do
    @default_globals_file_path = 'config/globals.yml'
    @permanent_file_path = 'config/immortal_globals.yml'
    # File.open(@default_globals_file_path, "w"){}
  end

  context "when initialize is called" do 

    it "should initialize all Adjective globals" do 
      Adjective::GlobalManager.initialize do |settings|

      end
      expect($item_instance_reference).to eq(0)
      expect($actor_instance_reference).to eq(0)
      expect($inventory_instance_reference).to eq(0)
    end

    context "when not loading from a file" do 
      it "should set custom values if supplied and not loading from file" do 
        Adjective::GlobalManager.initialize do |settings|
          settings[:custom_values] = {
            key: 0,
            other_global: 0
          }
        end
        expect($key).to eq(0)
        expect($other_global).to eq(0)
      end
    end

    context "when loading variables from a file" do 

      it "should load custom values from settings when file is loaded" do 
        Adjective::GlobalManager.initialize do |settings|
          settings[:custom_values] = {
              key: 0,
              other_global: 0
            }
        end
        expect($key).to eq(0)
        expect($other_global).to eq(0)
      end

      it "should load custom values when explicit settings file is loaded" do 
        Adjective::GlobalManager.initialize
        Adjective::GlobalManager.keys
        Adjective::GlobalManager.keys
        Adjective::GlobalManager.load_globals({reset: true, data: {custom: 99, other_global: 0}})
        Adjective::GlobalManager.keys
        Adjective::GlobalManager.keys
        Adjective::GlobalManager.keys
        Adjective::GlobalManager.load_globals({reset: true, data: {custom_dudes: 99, other_bodacious_global: 0}})
        Adjective::GlobalManager.keys
        ap Adjective::GlobalManager.view_globals
      end

    end
    

  end  

end