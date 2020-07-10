module Adjective

  # Status is different from something like an attack in that it applies
  # to things that afflict the subject for one or more turns.
  module Status

    include Adjective::Temporable


    # Initialize module data for Status
    # @param opts [Hash]
    # @return [Object]
    # @example
    #   class SurrogateClass
    #     include Adjective::Status
    #     initialize_status({affected_attributes: { hitpoints: 3}, max_duration: 5})
    #   end
    def initialize_status(opts = {}) 
      attributes = opts[:affected_attributes] 
      @modifiers = attributes ||= {}
      @affected_attributes = attributes.map{|entry| entry[0]}

      # @applied_at Can be used to track simple object intantation if class is created when status is applied.
      # TODO: If held in memory, opts will need to be given a :timestamp with a value comparable with a Time object. (Custom values should help?)
      # If the user wishes to sort by a specific attribute in Statusable, then they should pass a block and do so there. (Maybe?)
      @applied_at = opts[:timestamp] ||= Time.now

      [:initialized_at, :affected_attributes, :modifiers].each do |attribute| 
        self.class.send(:attr_reader, attribute)
      end
      
      initialize_temporality(opts)
      normalize_remaining_duration
      assign_affected_attributes
      return self
    end

    # Will perform tick functionality, whose default action is to reduce @remaining_duration (from Temporable) by 1.
    # Otherwise, it will accept a block and bypass all default functionality.
    # @param block [Block]
    # @return [Object]
    # @example
    #   SurrogateClass.tick
    def tick(&block)
      if block_given? 
        yield(self) 
      else
        # Default
        @remaining_duration -= 1
      end
      return self
    end

    # Checks if the status has a modifier present
    # @return [Boolean]
    # @example
    #   SurrogateClass.has_modifier?(:hitpoints)
    def has_modifier?(attribute)
      @modifiers.key?(attribute)
    end

    # Adds or updates the modifier hash. 
    # @param attribute [Symbol]
    # @param value [Integer, Float, String]
    # @return [Hash]
    # @example
    #   SurrogateClass.add_or_update_modifer(:hitpoints, 10)
    def add_or_update_modifier(attribute, value)
      if has_modifier?(attribute)
        @modifiers[attribute] = value
      else
        @modifiers.store(attribute, value)
      end
      assign_affected_attributes
      return @modifiers
    end

    # Updates the modifier in @modifiers. Will warn and NOT amend if modifier does not exist.
    # @param attribute [Symbol]
    # @param value [Integer, Float, String]
    # @return [Hash]
    # @example
    #   SurrogateClass.update_modifier(:hitpoints, 12)
    def update_modifier(attribute, value)
      if has_modifier?(attribute)
        @modifiers[attribute] = value
        assign_affected_attributes
      else
        warn("Attmepted to update a modifier that wasn't present: #{attribute}. Use #add_modifier or #add_or_update_modifier instead.")
      end
      return @modifiers
    end

    # Adds to the modifier to @modifiers. Will warn and NOT amend if modifier already exists.
    # @param attribute [Symbol]
    # @param value [Integer, Float, String]
    # @return [Hash]
    # @example
    #   SurrogateClass.add_modifer(:strength, 20)
    def add_modifier(attribute, value)
      if !has_modifier?(attribute)
        @modifiers.store(attribute, value)
        assign_affected_attributes
      else
        warn("Attempted to add duplicate modifier: #{attribute}. The new value has NOT been set. (Currently '#{@modifiers[attribute]}'.")
      end
      return @modifiers
    end 

    # Removes the specified modifier from @modifers. 
    # @param attribute [Symbol]
    # @param value [Integer, Float, String]
    # @return [Hash]
    # @example
    #   SurrogateClass.add_modifer(:strength, 20)
    def remove_modifier(attribute)
      if has_modifier?(attribute)
        temp = {}.store(attribute, modifiers[attribute])
        @modifiers.delete(attribute)
      else
        warn("Attempted to remove modifier that does not exist: #{attribute}")
      end
      return temp
    end

    private

    # Converts the modifier hash into a digestable array for other modules to use. Includes '@' in modifier value,
    # as the format for the metaprogramming in other modules requires the attribute to be called and set explicitly if not publicly writable.
    # This should most likely be left alone and not called outside of the implementation here.
    # @private
    # @return [Hash]
    def assign_affected_attributes
      @affected_attributes.map!{|attribute| ("@"+attribute.to_s).to_sym }
    end

  end
end