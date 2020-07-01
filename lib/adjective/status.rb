module Adjective
  module Status

    # Status is different from something like an attack in that it applies
    # to things that afflict the actor for more than one turn.
    # An attack would be instant the moment it resolves, but can leave a status effect.

    # What if the status is applied initially and can stack higher than initial application? (#DONE)

    def initialize_status(name, opts = {})
      @name = name || nil
  
      @duration = opts[:duration] ||= 0
      @max_duration = opts[:max_duration] ||= opts[:duration]
      @remaining_duration = opts[:remaining_duration] ||= opts[:duration]

      @initialized_at = Time.now

      @modifiers = opts[:affected_attributes]
      @affected_attributes = opts[:affected_attributes].map{|entry| entry[0] }

      self.class.send(:attr_accessor, :remaining_duration)
      [:name, :duration, :initialized_at, :affected_attributes, :modifiers].each do |attribute| 
        self.class.send(:attr_reader, attribute)
      end
      
      #converts the attributes over to instance variable form (@thing) for easier consumption elsewhere
      convert_attributes
    end

    # Tick functionality

    def tick(&block)
      # Reduce duration
      # Allow for block to modify
      # return list of things ticked so they can be applied with Statusable
      # This method is meant to be overridden if you want other 'tick' functionality.
      if block_given? 
        yield(self) 
      else
        # Default functionality.
        @duration -= 1
      end
      return self
    end

    def extend_by(extension)
      @remaining_duration += extension
      normalize_remaining_duration
    end    

    def normalize_remaining_duration
      @remaining_duration = @max_duration if @remaining_duration > @max_duration
      @remaining_duration = 0 if @remaining_duration < 0
    end    

    # # Utility methods

    def expired?
      @remaining_duration == 0
    end

    def expiring?
      # This method seems like a meme, but I think it makes sense
      @remaining_duration == 1
    end

    private

    def convert_attributes
      @affected_attributes.map!{|a| ("@"+a.to_s).to_sym }
    end
  end
end