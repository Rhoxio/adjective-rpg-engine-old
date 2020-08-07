module Adjective
  module Applicable
    # This module is going to be the home for @modifiers and related logic.
    def initialize_applicable(opts)
      @modifiers = opts[:modifiers]  ||= {}
    end

    # Checks if modifier is present
    # @return [Boolean]
    # @example
    #   MyStatus.has_modifier?(:hitpoints)
    def has_modifier?(attribute)
      @modifiers.key?(attribute)
    end

    # Adds or updates the modifier hash. 
    # @param attribute [Symbol]
    # @param value [Integer, Float, String]
    # @return [Hash]
    # @example
    #   MyStatus.add_or_update_modifer(:hitpoints, 10)
    def add_or_update_modifier(attribute, value)
      if has_modifier?(attribute)
        @modifiers[attribute] = value
      else
        @modifiers.store(attribute, value)
      end
      return @modifiers
    end

    # Updates the modifier in @modifiers. Will warn and NOT amend if modifier does not exist.
    # @param attribute [Symbol]
    # @param value [Integer, Float, String]
    # @return [Hash]
    # @example
    #   MyStatus.update_modifier(:hitpoints, 12)
    def update_modifier(attribute, value)
      if has_modifier?(attribute)
        @modifiers[attribute] = value
      else
        warn("[#{Time.now}]: Attempted to update a modifier that wasn't present: #{attribute}. Use #add_modifier or #add_or_update_modifier instead.")
      end
      return @modifiers
    end

    # Adds to the modifier to @modifiers. Will warn and NOT amend if modifier already exists.
    # @param attribute [Symbol]
    # @param value [Integer, Float, String]
    # @return [Hash]
    # @example
    #   MyStatus.add_modifer(:strength, 20)
    def add_modifier(attribute, value)
      if !has_modifier?(attribute)
        @modifiers.store(attribute, value)
      else
        warn("[#{Time.now}]: Attempted to add duplicate modifier: #{attribute}. The new value has NOT been set. (Currently '#{@modifiers[attribute]}').")
      end
      return @modifiers
    end 

    # Removes the specified modifier from @modifers. 
    # @param attribute [Symbol]
    # @param value [Integer, Float, String]
    # @return [Hash]
    # @example
    #   MyStatus.add_modifer(:strength, 20)
    def remove_modifier(attribute)
      if has_modifier?(attribute)
        temp = {}.store(attribute, modifiers[attribute])
        @modifiers.delete(attribute)
      else
        warn("[#{Time.now}]: Attempted to remove modifier that does not exist: #{attribute}")
      end
      return temp
    end    
  end
end