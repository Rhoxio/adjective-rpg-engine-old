RSpec.describe Adjective::GlobalManager do

  before(:example) do
    @default_globals_file_path = 'config/globals.yml'
    @permanent_file_path = 'config/immortal_globals.yml'
    # File.open(@default_globals_file_path, "w"){}
  end

  context "when initialize is called" do 

    it "should initialize all Adjective globals" do 
      Adjective::GlobalManager.initialize do |settings|
        settings[:adjective][:global_file_reference] = @permanent_file_path
      end
      expect($item_instance_reference).to eq(0)
      expect($actor_instance_reference).to eq(0)
      expect($inventory_instance_reference).to eq(0)
      expect($global_file_reference).to eq(@permanent_file_path)
    end

    context "when not loading from a file" do 
      it "should set custom values if supplied and not loading from file" do 
        Adjective::GlobalManager.initialize do |settings|
          settings[:load_from_file] = false
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
          settings[:adjective][:global_file_reference] = @permanent_file_path
          settings[:custom_values] = {
              key: 0,
              other_global: 0
            }
        end
        expect($key).to eq(0)
        expect($other_global).to eq(0)
      end

      it "should load custom values when explicit settings file is loaded" do 

      end

    end
    

  end  

end