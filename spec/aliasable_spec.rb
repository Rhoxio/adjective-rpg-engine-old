require 'spec_helper'

RSpec.describe Adjective::Aliasable do

  before(:example) do
    @flexible_class = SurrogateFlexible.new
  end

  describe "aliasable sandbox" do 
    it "will sandbox for me" do 
      ap @flexible_class
    end
  end
end