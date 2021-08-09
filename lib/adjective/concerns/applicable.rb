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
    #   MyStatus.has_modifier?("Healing")
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
    #   MyStatus.add_or_update_modifer("Healing", :hitpoints, 10)
    def add_or_update_modifier(name, attribute, value)
      modifier = find_modifier(name)
      return update_modifier(name, attribute, value) if modifier
      return add_modifier(name, attribute, value) if !modifier 
      return false
    end

    # Updates the modifier in @modifiers. Will warn and NOT amend if modifier does not exist.
    # @param attribute [Symbol]
    # @param value [Integer, Float, String]
    # @return [Hash]
    # @example
    #   MyStatus.update_modifier("Healing", :hitpoints, 10)
    def update_modifier(name, attribute, value)
      modifier = find_modifier(name)
      return false if !modifier
      modifier.affected_attributes.store(attribute, value)
      return modifier
    end

    # Adds to the modifier to @modifiers. Will warn and NOT amend if modifier already exists.
    # @param attribute [Symbol]
    # @param value [Integer, Float, String]
    # @return [Hash]
    # @example
    #   MyStatus.add_modifer("Healing", :hitpoints, 10)
    def add_modifier(name, attribute, value)
      if !has_modifier?(name)
        affected_attributes = {}.store(attribute, value)
        modifier = Modifier.new(name, affected_attributes)
        @modifiers.push(modifier)
      else
        return false
      end
      return modifier
    end 

    # Removes the specified modifier from @modifers. 
    # @param attribute [Symbol]
    # @param value [Integer, Float, String]
    # @return [Hash]
    # @example
    #   MyStatus.add_modifer("Healing")
    def remove_modifier(name)
      modifier = find_modifier(name)
      if modifier
        @modifiers = @modifiers.select {|mod| mod.name != name}
      else
        return false
      end
      return modifier
    end    
  end
end