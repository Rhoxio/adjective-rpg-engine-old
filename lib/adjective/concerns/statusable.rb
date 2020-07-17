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

      # These methods may not he so useful after all.
      # If the user applies a status and the class doesn't respond to it,
      # it should potentially do nothing and accept it due to it just not affecting the
      # target in any way. 
      # I will add them back in later if I see a use for them. 
      # validate_modifier_existence(status_collection)
      # validate_initial_attributes(status_collection)

      yield(self, status_collection) if block_given?
      @statuses = @statuses.concat(status_collection).flatten
      return @statuses
    end

    def sort_statuses!(attribute = :remaining_duration)
      valid = @statuses.all? {|status| status.respond_to?(attribute)}
      warn_about_missing_attribute(attribute, "#sort_statuses") if !valid
      @statuses = @statuses.sort_by { |status| status.send(attribute) } if valid
      return @statuses
    end

    def find_statuses(attribute = :remaining_duration, value = nil)
      results = []
      if value
        results = @statuses.select { |status| status.send(attribute) == value }
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

    def tick_all(&block)
      @statuses.each do |status|
        # It should potentially just skip the whole operation. Will add back later or amed
        # if issues crop up because of no validation.
        # validate_modifier_existence([status])
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
      return @statuses
    end

    def clear_expired_statuses
      unexpired = @statuses.select { |status| status.duration != 0 }
      diff = @statuses - unexpired
      @statuses = unexpired
      return diff
    end

    private

    # def validate_initial_attributes(given_statuses)
    #   invalids = given_statuses.map{|status| status.affected_attributes }.flatten.select {|att| !instance_variable_defined?(att) }
    #   warn_about_invalid_initial_attributes(invalids) if invalids.length > 0
    # end

    # def validate_modifier_existence(mods)
    #   raise RuntimeError, "Given status does not respond to #modifiers." if !mods.any? {|status| status.respond_to?(:modifiers)}
    # end    

    def warn_about_missing_attribute(attribute, method_name)
      warn("#{Time.now}]: Supplied an attribute to #{method_name} that doesn't exist on all statuses: #{attribute}")
    end

    def warn_about_invalid_initial_attributes(invalids)
      warn("[#{Time.now}]: Gave affected_attributes in a Status that are not present on #{self.class.name}: #{invalids}.")
    end

  end

end