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

    def initialize_skill(name = "Unnamed Skill", args = {})
      @name = name
      @skill_type = args[:skill_type] ||= :universal
      @statuses = args[:statuses] ||= { to_self: [], to_external: [] }
      fill_status_structure

      # @modifiers = args[:modifiers] ||= []
      

      # Modification on a per-skill basis will be handled directly by delegation through applicable.
      # Will need to set up specific delegations for each modifier type and the context in which they will
      # be applied. Probably just make lists, apply all, and make sure that the other modules only pull
      # the correct ones.

      # The problem with colliding keys can probably be easily fixed by making modifier into an object instead
      # of a hash. The problem is one of context, and applying context should be easier this way at any rate.
      # It might introduce some more DSL, but seems necessary as I can only think of two different conditions
      # (apply number in foreign context, apply number in self context) to elicit the correct mechanics.

      # This was fixed by making a Modifier object with a name. Each modifier may need to be changed individually, 
      # so aggregating them will be the responsibility of the module using the skill, not here in the base data modeling utlities.

      # A set might look like: 
      # @sets = {
      #    name: "Holy Strike",
      #    statuses: {to_self: [StatusObjects], to_external: [StatusObjects]}, 
      #    modifiers: [Modifiers],
      #    chained_skills: [Skills], 
      #    actions: &block
      # }

      [:name, :skill_type, :statuses].each do |attribute| 
        self.class.send(:attr_accessor, attribute)
      end

      initialize_temporality(args)
      initialize_applicable(args)
    end

    private

    def fill_status_structure
      @statuses.store(:to_self, []) if !@statuses.key?(:to_self)
      @statuses.store(:to_external, []) if !@statuses.key?(:to_external)
    end

  end
end