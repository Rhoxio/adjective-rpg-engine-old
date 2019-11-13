module Adjective
  class Status
    attr_reader :name, :duration, :initialized_at, :affected_attributes, :value
    attr_accessor :remaining

    def initialize(name, opts = {})
      @name = name || nil

      # Tracking
      @duration = opts[:duration] ||= 0
      @remaining = opts[:remaining] ||= @duration

      # Applying to?
      @value = opts[:value]
      @affected_attributes = Array(opts[:affected_attributes])

      # Timekeeping
      @initialized_at = Time.now

      post_initialize(opts)
    end

    # Tick functionality

    def tick(&block)
      # This method is meant to be overridden if you want other 'tick' functionality.
      yield(self) if block_given? 
      return expired? ? false : true
    end

    # Utility methods

    def post_initialize(opts)
      raise NotImplementedError, "Attempting to initialize from inintended superclass of 'Status'. Use 'Buff' or 'Debuff' instead."
    end

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

  end

  # Hybrid statuses should be extrapolated out into two different statuses.

  class Buff < Status

    def post_initialize(opts = {})
      # Will only take positive integers.

      # For each attribute on the target model, the buff will increase the value for a set
      # number of turns. @duration on the superclass Status will control this.

      # This is going to turn out to be more of a data model, but will be linkable to 
      # other actions in the Battle system, Actors, Items, and potentially inventories through Statusable.
      # It should handle and contain utility methods for other pieces to get a grasp on its state.

      # Eventually, these will need to go in some order in an array to be checked. (Probably order of application)
      # I am thinking that the buff will need to maintain its own state, as it is simply in association wth a particular model.

    end

  end

  class Debuff < Status
    def post_initialize(opts = {})

    end
  end
end