module Adjective

  module Temporable

    # This is to be used to emulate turn-based interactions or to emulate basic time within the context of a parent class. 

    # The idea behind setting an initial_duration is so you can see what the status started out as
    # instead of making an assumption. This could matter if multiple same-identity classes have the same attributes,
    # but have different durations linked to them. 

    # Initialize module data for Temporable
    # @param opts [Hash]
    # @return [Object]
    # @example
    #   initialize_temporality({max_duration: 5, remaining_duration: 4})
    def initialize_temporality(opts={})
      @max_duration = opts[:max_duration] ||= 1
      @remaining_duration = opts[:remaining_duration] ||= @max_duration

      throw_duration_theshold_error if invalid_durations?

      [:max_duration, :remaining_duration].each do |attribute| 
        self.class.send(:attr_accessor, attribute)
      end
      normalize_remaining_duration 
      return self     
    end

    # Checks if the status is at it's maximum duration
    # @return [Boolean]
    # @example
    #   SurrogateClass.max_duration? #=> True/False
    def max_duration?
      @max_duration == @remaining_duration
    end

    # Checks if remaining_duration is at 0.
    # @return [Boolean]
    # @example
    #   SurrogateClass.expired? #=> True/False
    def expired?
      @remaining_duration == 0
    end

    # Checks if remaining_duration is at 1.
    # @return [Boolean]
    # @example
    #   SurrogateClass.expired? #=> True/False
    def expiring?
      # This method seems like a meme, but I think it makes sense
      @remaining_duration == 1
    end

    # Checks and sets remaining_duration if it is out of bounds.
    # @return [Integer]
    # @example
    #   SurrogateClass.normalize_remaining_duration
    def normalize_remaining_duration
      @remaining_duration = @max_duration if @remaining_duration > @max_duration
      @remaining_duration = 0 if @remaining_duration < 0
    end   

    # Extends the duration and keeps it within bounds.
    # @param extension [Integer]
    # @return [Integer]
    # @example
    #   SurrogateClass.extend_by(2)
    def extend_by(extension)
      @remaining_duration += extension
      normalize_remaining_duration
      return @remaining_duration
    end           

    private

    # Triggers error to the thrown is thesholds are exceeed on initialization.
    # @return [Boolean]
    # @private
    # @example
    #   SurrogateClass.throw_duration_threshold_error
    def throw_duration_theshold_error
      raise ArgumentError, "Provded initial_duration or remaining_duration values exceed max_duration: max: #{@max_duration}, remaining: #{@remaining_duration}."
    end

    # Checks if initial durations are valid.
    # @return [Boolean]
    # @example
    #   SurrogateClass.invalid_durations?
    def invalid_durations?
      @remaining_duration > @max_duration
    end    
  end

end