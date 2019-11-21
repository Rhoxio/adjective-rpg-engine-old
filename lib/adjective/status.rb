module Adjective
  class Status
    attr_reader :name, :duration, :initialized_at, :affected_attributes, :modifiers
    attr_accessor :remaining

    def initialize(name, opts = {})
      @name = name || nil
      @duration = opts[:duration] ||= 0
      @remaining = opts[:remaining] ||= @duration
      @initialized_at = Time.now
      @modifiers = opts[:affected_attributes]
      @affected_attributes = opts[:affected_attributes].map{|entry| entry[0] }
      convert_attributes
    
    end

    # Tick functionality

    def tick(&block)
      # This method is meant to be overridden if you want other 'tick' functionality.
      yield(self) if block_given? 
      return expired? ? false : true
    end

    # Utility methods

    def expired?
      @remaining == 0
    end

    def expiring?
      # This method seems like a meme, but I think it makes sense
      @remaining == 1
    end

    def instant?
      # If the duration is 0, it should apply immediately for a single turn.
      @duration == 0
    end

    def over_time?
      @duration > 1 || @duration == :unlimited
    end

    private

    def convert_attributes
      @affected_attributes = @affected_attributes.map{|a| ("@"+a.to_s).to_sym }
    end
  end
end