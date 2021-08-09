module Adjective
  module Applicable
    # This module is going to be the home for @modifiers and related logic.
    def initialize_applicable(opts)
      @modifiers = opts[:modifiers] ||= []
      self.class.send(:attr_reader, :modifiers)
    end

    # Checks if modifier is present
    # @return [Boolean]
    # @example
    #   MyStatus.has_modifier?(:hitpoints)
    def has_modifier?(name)
      @modifiers.any?{|mod| mod.name == name }
    end

    def find_modifier(name)
      target = @modifiers.select {|mod| mod.name == name }
      return target[0] if target.length > 0
      return false
    end

    # Adds or updates the modifier hash. 
    # @param attribute [Symbol]
    # @param value [Integer, Float, String]
    # @return [Hash]
    # @example
    #   MyStatus.add_or_update_modifer(:hitpoints, 10)
    def add_or_update_modifier(name, attribute, value)
      modifier = find_modifier(name)
      if modifier
        modifier.affected_attributes.store(attribute, value)
      else
        affected_attributes = {}.store(attribute, value)
        modifier = Modifier.new(name, affected_attributes)
        @modifiers.push(modifier)
      end
      return modifier
    end

    # Updates the modifier in @modifiers. Will warn and NOT amend if modifier does not exist.
    # @param attribute [Symbol]
    # @param value [Integer, Float, String]
    # @return [Hash]
    # @example
    #   MyStatus.update_modifier(:hitpoints, 12)
    def update_modifier(name, attribute, value)
      modifier = find_modifier(name)
      if modifier
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