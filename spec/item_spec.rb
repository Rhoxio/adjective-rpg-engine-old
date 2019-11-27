# RSpec.describe Adjective::Item do 
#   before(:example) do   
#     # Before action sets and uses instance_id of 1 automatically...
#     @item = SurrogateItem.new()
#   end

#   context "when initialized" do

#     it "will increment the corresponding global instance id variable" do 
#       5.times {Adjective::Item.new()}
#       # We iterate 5 times: 5 + 1 (@item) + 1 (counter increment after init of a model) = 7
#       expect($item_instance_ref).to eq(7)
#     end

#   end

#   context "when assigned custom instance variables" do 

#     # uses are defined in spec_helper and default to 5 for this test model
#     it "will respond when a getter method is called" do 
#       @tomato = SurrogateItem.new({id: 1})
#       expect(@tomato.uses).to eq(5)
#     end

#     it "will respond when a setter method is called" do 
#       @tomato = SurrogateItem.new({id: 1})
#       @tomato.uses = 10
#       expect(@tomato.uses).to eq(10)
#     end    
#   end

#   context "when query_string is called" do 
#     it "returns the string expected with default options" do 
#       expect(@item.query_string).to eq("instance_id&:1&:name&:&:created_at&:#{Time.now.to_s}&:")
#     end

#     it "returns the string expected with :attributes scope" do 
#       expect(@item.query_string(:attributes)).to eq("instance_id&:name&:created_at&:")
#     end

#     it "returns the string expected with :values scope" do 
#       expect(@item.query_string(:values)).to eq("1&:&:#{Time.now.to_s}&:")
#     end
#   end

# end