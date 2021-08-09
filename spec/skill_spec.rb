RSpec.describe Adjective::Skill do 
  before(:all) do 
    @skill = SurrogateSkill.new("Basic Attack", {skill_type: :offensive, modifiers: { hitpoints: -3}, indefinite: true})
  end

  describe "when created" do 
    it "will sandbox for me" do 
      ap @skill.modifiers
    end

    it "will throw an attribute error if no skill_type is supplied" do 
      expect{SurrogateSkill.new("Basic Attack", {})}.to raise_error(ArgumentError)
    end

    it "will raise an error if a bad skill type is supplied" do 
      expect{SurrogateSkill.new("Basic Attack", {skill_type: :bunk})}.to raise_error(ArgumentError)
    end

  end
end