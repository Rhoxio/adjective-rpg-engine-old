module Adjective
  class Status
    attr_reader :name, :duration, :initialized_at

    def initialize(name, opts = {})
      @name = name
      @duration = opts[:duration] ||= 0
      @initialized_at = Time.now

      post_initialize(opts)
    end

    def post_initialize(opts)
      raise NotImplementedError, "Attempting to initialize from inintended superclass of 'Status'. Use 'Buff' or 'Debuff' instead."
    end

    def tick
      
    end

    def instant?
      # If the duration is 0, it should apply immediately.
      @duration == 0
    end

    def over_time?
      @duration > 1 || @duration == :unlimited
    end

  end

  class Buff < Status
    def post_initialize(opts = {})

    end

    def thnig
      # take in proc on iteration and amend value based on what is passed in it
      # this will be part of a 'tick' mechanic that keeps track of 
    end
  end

  class Debuff < Status
    def post_initialize(opts = {})

    end
  end
end