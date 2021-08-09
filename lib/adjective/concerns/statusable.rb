module Adjective

  # I plan on having this module handle the messier side of buff/debuff processing
  # It will need to include a way to manage the coupling between Status and the target model.
  # It will need to be able to process and return values that can be easily passed into other
  # methods. 

  module Statusable

    # Initialize module data for Statusable
    # @return [Object]
    # @example
    #   class SurrogateClass
    #     include Adjective::Statusable
    #     initialize_status_data
    #   end
    def initialize_status_data
      @statuses = []
      self.class.send(:attr_accessor, :statuses)
      return self
    end

    # Will apply one or multiple statuses to the parent class through @statuses.
    # @param status_collection [Array]
    # @param block [Block]
    # @return [Array]
    # @example
    #   SurrogateClass.apply_statuses(@stats)
    #   SurrogateClass.apply_statuses([@status, @status2, @status3])
    def apply_statuses(status_collection, &block)
      status_collection = [status_collection].flatten
      yield(self, status_collection) if block_given?
      @statuses = @statuses.concat(status_collection).flatten
      return @statuses
    end

    # Will remove all matching statuses from parent class through @statuses.
    # @param attribute [Symbol]
    # @param value [Object]
    # @return [Array]
    # @example
    #   SurrogateClass.remove_statuses(:name, "Poison")
    def remove_statuses(attribute = :remaining_duration, value = nil)
      to_remove = find_statuses(attribute, value)
      @statuses = @statuses.reject{|status| to_remove.include?(status)}
      reset_amended_attributes(to_remove.select { |status| status.reset_references != {} })
      return to_remove
    end

    # Will remove first matching statuses from parent class through @statuses.
    # @param attribute [Symbol]
    # @param value [Object]
    # @return [Object]
    # @example
    #   SurrogateClass.remove_status(:name, "Poison")
    def remove_status(attribute = :remaining_duration, value = nil)
      to_remove = find_statuses(attribute, value).first
      @statuses = @statuses.reject{|status| status == to_remove }
      reset_amended_attributes([to_remove]) if to_remove.reset_references != {}
      return to_remove
    end

    # Will find all matching statuses from parent class through @statuses.
    # @param attribute [Symbol]
    # @param value [Object]
    # @return [Array]
    # @example
    #   SurrogateClass.find_statuses(:name, "Fatigue")
    def find_statuses(attribute = :remaining_duration, value = nil)
      results = []
      responds = @statuses.select {|status| status.respond_to?(attribute)}
      if value
        results = responds.select { |status| status.public_send(attribute) == value }
      else
        results = responds
      end
      return results
    end

    # Will find single matching status from parent class through @statuses.
    # @param attribute [Symbol]
    # @param value [Object]
    # @return [Object]
    # @example
    #   SurrogateClass.find_status(:name, "Fatigue")
    def find_status(attribute = :remaining_duration, value)
      return find_statuses(attribute, value).first
    end    

    # Will sort @statuses by attribute or method.
    # @param attribute [Symbol]
    # @return [Array]
    # @example
    #   SurrogateClass.sort_statuses!(:name)
    def sort_statuses!(attribute = :remaining_duration)
      responds = @statuses.select {|status| status.respond_to?(attribute)}
      does_not_respond = @statuses.select {|status| !status.respond_to?(attribute)}
      @statuses = responds.sort_by { |status| status.public_send(attribute) } + does_not_respond
      return @statuses
    end


    # Will check if status matching given arguments exists in @statuses. 
    # @param attribute [Symbol]
    # @param match [Object]
    # @return [Boolean]
    # @example
    #   SurrogateClass.has_status?(:name, "Poison")
    def has_status?(attribute, match)
      @statuses.each do |status|
        if status.respond_to?(attribute)
          return true if status.public_send(attribute) == match
        end
      end
      return false
    end   

    # Will cycle through all entries of @statuses and apply default tick functionality to each. 
    # You can pass a block to bypass all default functionality. It also accepts a proc object to be evoked before 
    # each status is ticked, allowing for specific one-off modification. 
    # @param opts [Hash]
    # @param status_proc [Proc]
    # @param block [Block]
    # @return [Array]
    # @example
    #   SurrogateClass.tick_all
    #   SurrogateClass.tick_all({clear_expired: false})
    #   SurrogateClass.tick_all({clear_expired: true}, Proc.new {|status| p "do something cool with #{status.name}"})
    #   SurrogateClass.tick_all {|klass, statuses| p "klass is the parent class, and statuses is @statuses"}
    def tick_all(status_proc = nil, opts = {clear_expired: true}, &block)
      if block_given? 
        yield(self, @statuses)
      else
        @statuses.each do |status|
          status_data = status.tick(status_proc)
          source = status_data.delete(:source)

          # Will need to collect all of the total values from each tick.
          collected_status_data = {}
          status_data.each do |name, effect|
            effect.each do |attribute, value|
              if collected_status_data.key?(attribute)
                collected_status_data[attribute] += value
              else
                collected_status_data[attribute] = value
              end
            end
          end

          collected_status_data.each do |attribute, value|
            attribute = attribute.to_s
            if self.respond_to?(attribute+"=")
              if status.tick_type == :linear
                eval("self.#{attribute} += #{value}")
              elsif status.tick_type == :static
                public_send("#{attribute}=", value)
              elsif status.tick_type == :compounding
                eval("self.#{attribute} += #{value}")
              end
            end            
          end
        end
      end 
      clear_expired_statuses! if opts[:clear_expired]
      return @statuses
    end

    # Will clear all expired statuses and reset any :static tick_type statuses values back to their corresponding reset_reference
    # @return [Array]
    # @example
    #   SurrogateClass.clear_expired_statuses!
    def clear_expired_statuses!
      unexpired = @statuses.select { |status| status.remaining_duration > 0 }
      expired = @statuses.select { |status| status.remaining_duration <= 0 }
      diff = @statuses - unexpired
      reset_amended_attributes(expired.select { |status| status.reset_references != {} })
      @statuses = unexpired
      return diff
    end

    private

    def reset_amended_attributes(status_collection)
      status_collection.each do |status|
        status.reset_references.each do |attribute, method|
          public_send("#{attribute}=", public_send(method))
        end
      end
    end     

  end

end