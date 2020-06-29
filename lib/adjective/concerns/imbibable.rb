module Adjective

  module Imbibable
    # Able to be enhanced by experience

    def initialize_experience(opts)
      @level = opts[:level] ||= 1
      @experience = opts[:initial_exp] ||= 0
      # This may throw an error if the user decides to instantiate a class without a table present.
      @active_exp_set = opts[:exp_table]
      [:active_exp_set, :level].each {|attribute| self.class.send(:attr_reader, attribute)}
      self.class.send(:attr_accessor, :experience)
      set_experience_to_level_minimum
    end

    def set_experience_to_level_minimum
      @experience = @active_exp_set[@level]
    end

    def level_up
      until !can_level_up?
        @level += 1
      end
    end

    # Level down functionality should work the same way as simply setting a level.

    def normalize_experience
      @experience = 0 if @experience < 0
    end        

    def max_level
      @active_exp_set.length - 1
    end  

    def max_level?
      @active_exp_set.length - 1 <= @level
    end
    
    def can_level_up?
      return false if max_level?
      @experience >= @active_exp_set[@level+1]
    end  

    def grant_experience(exp, opts = {})
      return false if max_level?
      @experience += exp
      level_up if !opts[:suppress_level_up]      
    end

    def set_level(num, opts = {})
      @level = num
      @experience = @active_exp_set[num] if !opts[:constrain_exp]
    end

    def grant_levels(num, opts = {})
      @level += num
      @experience = @active_exp_set[@level] if !opts[:constrain_exp] 
    end 

    def experience_to_next_level
      return nil if max_level?
      return @active_exp_set[@level+1] - @experience
    end 


  end

end