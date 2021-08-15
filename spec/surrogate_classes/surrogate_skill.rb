class SurrogateSkill

  include Adjective::Skill

  def initialize(name, opts)
    initialize_skill(name, opts) do |skill|

    end
  end
end

class SurrogateSkillTwo

  include Adjective::Skill

  def initialize(name, opts)
    initialize_skill(name, opts) do |skill|
      skill.name = "Bash"
    end
  end
end