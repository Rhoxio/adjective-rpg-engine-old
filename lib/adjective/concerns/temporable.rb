module Adjective

  module Temporable

    # This is to be used to emulate turn-based interactions or to emulate basic time within the context of a parent class. 

    # The idea behind setting an initial_duration is so you can see what the status started out as
    # instead of making an assumption. This could matter if multiple same-identity classes have the same attributes,
    # but have different durations linked to them. 

    def initialize_temporality(opts={})
      @max_duration = opts[:max_duration] ||= 1
      @remaining_duration = opts[:remaining_duration] ||= @max_duration

      throw_duration_theshold_error if invalid_durations?

      [:max_duration, :remaining_duration].each do |attribute| 
        self.class.send(:attr_accessor, attribute)
      end
      normalize_remaining_duration      
    end

    def max_duration?
      @max_duration == @remaining_duration
    end

    def expired?
      @remaining_duration == 0
    end

    def expiring?
      # This method seems like a meme, but I think it makes sense
      @remaining_duration == 1
    end

    def normalize_remaining_duration
      @remaining_duration = @max_duration if @remaining_duration > @max_duration
      @remaining_duration = 0 if @remaining_duration < 0
    end   

    def extend_by(extension)
      @remaining_duration += extension
      normalize_remaining_duration
    end           

    private

    def throw_duration_theshold_error
      raise ArgumentError, "Provded initial_duration or remaining_duration values exceed max_duration: max: #{@max_duration}, initial: #{@initial_duration}, remining: #{@remaining_duration}."
    end

    def invalid_durations?
      @remaining_duration > @max_duration
    end    
  end

end