RSpec.describe Adjective::GlobalManager do

  before(:example) do
    Adjective::GlobalManager.initialize_globals do |settings|
      settings[:adjective][:item_instance_reference] = 1000909342
      settings[:custom_values] = {
        skill_point_reference: 0,
        max_economy_reference: 12000
      }
      settings[:save_on_start] = true
    end
  end

  context "when initialize_globals id called" do 
    it "should initialize globals with values of 0 by default" do 

      # Adjective::GlobalManager.initialize_globals
      # expect($item_instance_reference).to eq(0)
      # Adjective::GlobalManager.initialize_globals(:default, "config/globals.yml")
      # Adjective::GlobalManager.save_globals! do |globals|
      #   globals[:arbitrary] = 69
      #   globals[:dooky] = 99003
      # end
    end
  end  

end