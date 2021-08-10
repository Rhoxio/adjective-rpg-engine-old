RSpec.describe Adjective::Skill do 
  before(:all) do 
    @skill = SurrogateSkill.new("Basic Attack", {skill_type: :offensive, modifiers: { hitpoints: -3}, indefinite: true})
  end

  describe "when created" do 
    it "will sandbox for me" do 
      # ap @skill.modifiers
    end

    it "will default skill_type to :universal if no arg is passed for it" do 
      expect(SurrogateSkill.new("Basic Attack", {}).skill_type).to eq(:universal)
    end

    it "will default statuses hash if arg does not exist" do 
      expect(SurrogateSkill.new("Basic Attack", {}).statuses).to eq({ to_self: [], to_external: [] })
    end

    it "will fill status structure if either of the required keys are missing" do 
      expect(SurrogateSkill.new("Basic Attack", {to_self: []}).statuses).to eq({ to_self: [], to_external: [] })
      expect(SurrogateSkill.new("Basic Attack", {to_external: []}).statuses).to eq({ to_self: [], to_external: [] })
    end

    context "from outside modules" do 
      it "will initialize modifiers array as empty if no args are passed" do 
        expect(SurrogateSkill.new("Basic Attack", {}).modifiers).to eq([])
      end
    end
    
  end
end