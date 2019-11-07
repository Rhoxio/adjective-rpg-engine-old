module Adjective
  class Status
    def initialize(name, opts = {})
      @name = name
      @duration = opts[:duration] ||= 0
      @type_of = opts[:type_of] ||= :buff
      @
      @initialized_at = Time.now
    end

    def instant?
      # If the duration is 0, it should apply immediately.
      @duration == 0
    end

    def over_time?
      @duration > 1 || @duration == :unlimited
    end

    def type_of

    end

    private

    def type_of_types
      [:healing, :damage, :buff, :debuff]
    end 
  end
end