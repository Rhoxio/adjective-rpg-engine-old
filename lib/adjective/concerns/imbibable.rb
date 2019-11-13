module Adjective

  module Imbibable

    def initialize_experience(opts)
      @level = opts[:level] ||= 1
      @experience = opts[:initial_exp] ||= 0
      @active_exp_set = opts[:exp_table]
      [:active_exp_set, :experience, :level].each {|attribute| self.class.send(:attr_reader, attribute)}
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

    def normalize_experience
      @experience = 0 if @experience < 0
    end        

    # def level_down
    #   if experience < @active_exp_set[@level]
    #     @level -=1
    #     return true
    #   else
    #     return false
    #   end
    # end 
    #  0  1   2   3   4   5   6   7   8    9    10
    # [0,200,300,400,500,600,700,800,900,1000, 1200]

    def max_level
      # Essentially dropping the 0 index so we can access directly with an integer, not int - 1
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
      level_up if !opts[:suppress_levels]      
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

    # def grant_experience(exp_to_grant, opts = {})
    #   # Only takes positive integers - should avoid bugs and underflow this way.
    #   if exp_to_grant < 0
    #     raise RuntimeError, "[#{Time.now}]: Provided value in #grant_experience (#{exp_to_grant}) is not a positive integer."
    #   else
    #     @experience += exp_to_grant
    #     normalize_experience
 
    #     if !opts[:suppress_levels]
    #       until !can_level_up?
    #         level_up
    #       end
    #     end

    #     return { :exp_granted => exp_to_grant, :total_exp => @experience }
    #   end   
    # end

    # def subtract_experience(exp_to_subtract, opts = {})
    #   # Only takes positive integers - should avoid bugs and underflow this way.
    #   if exp_to_subtract < 0
    #     raise RuntimeError, "#{Time.now}]: Provided value in #subtract_experience (#{exp_to_subtract}) is not a positive integer."
    #   else
    #     @experience -= exp_to_subtract
    #     normalize_experience

    #     if !opts[:suppress_levels]
    #       until !level_down
    #         level_down
    #       end
    #     end

    #   end 
    # end   

  end

end