module Adjective
  module Skill
    # The baseline module for integration with Acquirable

    def initialize_skill(opts = {})
      @skill_type = opts[:skill_type] ||= :utility
      @modifiers = opts[:modifiers] ||= {}
    end

    def evoke
      # Like "use"
    end 

  end
end