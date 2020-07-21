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

    def sort_statuses!(attribute = :remaining_duration)
      responds = @statuses.select {|status| status.respond_to?(attribute)}
      does_not_respond = @statuses.select {|status| !status.respond_to?(attribute)}
      @statuses = responds.sort_by { |status| status.send(attribute) } + does_not_respond
      return @statuses
    end

    def remove_status(attribute = :remaining_duration, value = nil)
      to_remove = find_statuses(attribute, value)
      @statuses = @statuses.reject{|status| to_remove.include?(status)}
      return to_remove
    end

    def find_statuses(attribute = :remaining_duration, value = nil)
      results = []
      if value
        responds = @statuses.select {|status| status.respond_to?(attribute)}
        results = responds.select { |status| status.send(attribute) == value }
      else
        results = @statuses.select { |status| status.respond_to?(attribute) }
      end
      return results
    end

    def has_status?(attribute, match)
      @statuses.each do |status|
        if status.respond_to?(attribute)
          return true if status.send(attribute) == match
        end
      end
      return false
    end

    def tick_all(opts = {clear_expired: true}, &block)
      @statuses.each do |status|
        status.modifiers.each do |key, value|
          attribute = key.to_s
          if (value.is_a?(Integer) || value.is_a?(Float))
            eval("self.#{attribute} += #{value}") if self.respond_to?(attribute+"=")
          else
            send("#{attribute}=", value) if self.respond_to?(attribute+"=")
          end
        end
        # status.tick will reduce the remaining_duration by 1 by default.
        status.tick
      end
      yield(self, @statuses) if block_given?
      clear_expired_statuses! if opts[:clear_expired]
      return @statuses
    end

    def clear_expired_statuses!
      unexpired = @statuses.select { |status| status.remaining_duration > 0 }
      diff = @statuses - unexpired
      @statuses = unexpired
      return diff
    end

  end

end