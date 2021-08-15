RSpec.describe Adjective::Skill do 
  before(:all) do 
    @modifier = Adjective::Modifier.new("Damage", {hitpoints: 5})
    @skill = SurrogateSkill.new("Basic Attack", {skill_type: :offensive, modifiers: [@modifier], indefinite: true})
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

    it "will accept skills in chained_skills" do 
      skill_one = SurrogateSkill.new("Basic Attack", {skill_type: :offensive, modifiers: [@modifier], indefinite: true})
      skill_two = SurrogateSkill.new("Basic Attack", {skill_type: :offensive, modifiers: [@modifier], indefinite: true})
      target_skill = SurrogateSkill.new("Basic Attack", {skill_type: :offensive, modifiers: [@modifier], chained_skills: [skill_one, skill_two], indefinite: true})
      expect(target_skill.chained_skills.length).to eq(2)
    end

    it "will accept a block on initialization" do 
      # SurrogateSkillTwo holds the block
      skill = SurrogateSkillTwo.new("Basic Attack", {skill_type: :offensive, modifiers: [@modifier], indefinite: true})
      expect(skill.name).to eq("Bash")
    end

    context "from outside modules" do 
      it "will initialize modifiers array as empty if no args are passed" do 
        expect(SurrogateSkill.new("Basic Attack", {}).modifiers).to eq([])
      end
    end
    
  end
end