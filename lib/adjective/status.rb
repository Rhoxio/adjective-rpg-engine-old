module Adjective
  module Status

    include Adjective::Temporable

    # Status is different from something like an attack in that it applies
    # to things that afflict the actor for one or more turns.

    def initialize_status(opts = {}) 
      attributes = opts[:affected_attributes] 
      @modifiers = attributes ||= {}
      @affected_attributes = attributes.map{|entry| entry[0] }

      # Can be used to track simple object intantation if class is created when status is applied.
      # If held in memory, opts will need to be given a :timestamp with a value comparable with a Time object. 
      # (Maybe... might not work with Statusable as a default option without ergregious fenagaling)
      @applied_at = opts[:timestamp] ||= Time.now

      [:initialized_at, :affected_attributes, :modifiers].each do |attribute| 
        self.class.send(:attr_reader, attribute)
      end
      
      initialize_temporality(opts)
      normalize_remaining_duration
      assign_affected_attributes
    end

    # Tick functionality

    def tick(&block)
      if block_given? 
        yield(self) 
      else
        # Default
        @remaining_duration -= 1
      end
      return self
    end

    def add_attribute(attribute, value)
      if !@modifiers.key?(attribute)
        @modifiers.store(attribute, value)
        assign_affected_attributes
        return @modifiers
      else
        warn("Attempted to add duplicate attribute: #{attribute}. The new value has not been set. (Currently '#{@modifiers[attribute]}'.")
        return false
      end
    end 

    private

    def assign_affected_attributes
      @affected_attributes.map!{|attribute| ("@"+attribute.to_s).to_sym }
    end
  end
end