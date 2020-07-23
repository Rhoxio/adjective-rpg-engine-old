module Adjective

  # I plan on having this module handle the messier side of buff/debuff processing
  # It will need to include a way to manage the coupling between Status and the target model.
  # It will need to be able to process and return values that can be easily passed into other
  # methods. 

  module Statusable

    def initialize_status_data
      @statuses = []
      self.class.send(:attr_accessor, :statuses)
    end

    def apply_statuses(status_collection, &block)
      status_collection = [status_collection].flatten
      yield(self, status_collection) if block_given?
      @statuses = @statuses.concat(status_collection).flatten
      return @statuses
    end

    def remove_statuses(attribute = :remaining_duration, value = nil)
      to_remove = find_statuses(attribute, value)
      @statuses = @statuses.reject{|status| to_remove.include?(status)}
      return to_remove
    end

    def remove_status(attribute = :remaining_duration, value = nil)
      to_remove = find_statuses(attribute, value).first
      @statuses = @statuses.reject{|status| status == to_remove }
      return to_remove
    end

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

    def find_status(attribute = :remaining_duration, value)
      return find_statuses(attribute, value).first
    end    

    def sort_statuses!(attribute = :remaining_duration)
      responds = @statuses.select {|status| status.respond_to?(attribute)}
      does_not_respond = @statuses.select {|status| !status.respond_to?(attribute)}
      @statuses = responds.sort_by { |status| status.public_send(attribute) } + does_not_respond
      return @statuses
    end

    def has_status?(attribute, match)
      @statuses.each do |status|
        if status.respond_to?(attribute)
          return true if status.public_send(attribute) == match
        end
      end
      return false
    end   

    def tick_all(opts = {clear_expired: true}, status_proc = nil, &block)
      if block_given? 
        yield(self, @statuses)
      else
        @statuses.each do |status|
          status.modifiers.each do |key, value|
            attribute = key.to_s
            if self.respond_to?(attribute+"=")
              if status.tick_type == :linear
                eval("self.#{attribute} += #{value}")
              elsif status.tick_type == :static && (status.max_duration == status.remaining_duration)
                public_send("#{attribute}=", value)
              elsif status.tick_type == :compounding
                compounded_value = value * ((status.max_duration - status.remaining_duration) + 1)
                compounded_value = value if status.max_duration == status.remaining_duration
                eval("self.#{attribute} += #{compounded_value}")
              end
            end
          end
          status.tick
          status_proc.call(status) if status_proc
        end
      end 
      clear_expired_statuses! if opts[:clear_expired]
      return @statuses
    end

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