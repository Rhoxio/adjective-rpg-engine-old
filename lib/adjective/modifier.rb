
# The problem with colliding keys can probably be easily fixed by making modifier into an object instead
# of a hash. The problem is one of context, and applying context should be easier this way at any rate.
# It might introduce some more DSL, but seems necessary as I can only think of two different conditions
# (apply number in foreign context, apply number in self context) to elicit the correct mechanics.

# The context will actually probably need to be applied based on the skill, not the modifier. The modifier only needs a name
# as a label and the things that it affects directly.

module Adjective
  class Modifier

    attr_accessor :name, :affected_attributes

    def initialize(name = "Unnamed Modifier", affected_attributes = {})
      @name = name 
      @affected_attributes = affected_attributes ||= {}
    end

  end
end