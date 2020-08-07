module Adjective
  module Skill
    # The baseline module for integration with Acquirable

    include Adjective::Applicable
    include Adjective::Temporable

    def initialize_skill(opts = {})
      @skill_type = opts[:skill_type] ||= :utility
      @modification_factor = opts[:modification_factor] ||= Proc.new { |value| value } 

      [:skill_type, :modification_factor].each do |attribute| 
        self.class.send(:attr_reader, attribute)
      end

      initialize_temporality(opts)
      initialize_applicable(opts)
    end

    def invoke
      
    end 

  end
end