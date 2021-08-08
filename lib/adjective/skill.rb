module Adjective
  module Skill
    # The baseline module for integration with Acquirable

    # Essentially, this will take in values and return baseline values including modifiers in the context in which they
    # should be processed by other modules. This is a data class, not an action-type module!

    # Use Cases enumarable
    # Uses an attack
    # Applies a status
    # 

    include Adjective::Applicable
    include Adjective::Temporable

    def initialize_skill(name = "Unnamed Skill", opts = {})
      @name = name
      validate_inputs(opts)
      @skill_type = opts[:skill_type]
      @statuses = {

      }

      # Modification on a per-skill basis will be handled directly by delegation through applicable.
      # Will need to set up specific delegations for each modifier type and the context in which they will
      # be applied. Probably just make lists, apply all, and make sure that the other modules only pull
      # the correct ones.

      # The problem with colliding keys can probably be easily fixed by making modifier into an object instead
      # of a hash. The problem is one of context, and applying context should be easier this way at any rate.
      # It might introduce some more DSL, but seems necessary as I can only think of two different conditions
      # (apply number in foreign context, apply number in self context) to elicit the correct mechanics.

      # A set might look like: 
      # @sets = {
      #    name: "Holy Strike",
      #    statuses: {to_self: [StatusObjects], to_enemies: [StatusObjects]}, 
      #    modifiers: [Modifiers],
      #    chained_skills: [Skills], 
      #    actions: &block
      # }

      [:name, :skill_type, :statuses].each do |attribute| 
        self.class.send(:attr_accessor, attribute)
      end

      initialize_temporality(opts)
      initialize_applicable(opts)
    end

    def invoke
      # Skill types will include: utility, offensive, defensive 
    end 

    private

    def validate_inputs(opts)
      raise ArgumentError, "Did not provide a skill_type to Status: #{self}" if !opts.key?(:skill_type)
      raise ArgumentError, "Provided a bad skill_type of: #{opts[:skill_type]}" if !valid_skill_types.include?(opts[:skill_type])
    end

    def valid_skill_types
      [:utility, :offensive, :defensive]
    end

  end
end