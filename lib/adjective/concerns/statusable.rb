module Adjective

  # I plan on having this module handle the messier side of buff/debuff processing
  # It will need to include a way to manage the coupling between Status and the target model.
  # It will need to be able to process and return values that can be easily passed into other
  # methods. 

  module Statusable

    def initialize_status_data
      @statuses = []
      self.class.send(:attr_accessor, :buffs)
      self.class.send(:attr_accessor, :debuffs)
      self.class.send(:attr_accessor, :statuses)    
    end

    def apply_status(status, &block)
      validate_modifier_existence(status)
      check_attributes(status.affected_attributes)
      yield(self, status) if block_given?
      @statuses.push(status)
      return @statuses
    end

    def tick_all(&block)
      # Provides baseline functionality to + or - values from a given status, as this is
      # the most common of implementations.
      # Strings and other values are simply set.
      # Yielding to an arbitrary block should curcumvent any issues with extension and post-effect hooks. 
      @statuses.each do |status|
        validate_modifier_existence(status)
        status.modifiers.each do |key, value|
          attribute = key.to_s
          if (value.is_a?(Integer) || value.is_a?(Float))
            eval("self.#{attribute} += #{value}") if self.respond_to?(attribute+"=")
          else
            send("#{attribute}=", value) if self.respond_to?(attribute+"=")
          end
        end
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

    def check_attributes(affected_attributes)
      invalid = affected_attributes.select {|att| !instance_variable_defined?(att) }
      warn_about_attributes if invalid.length > 0
    end

    def validate_modifier_existence(status)
      raise RuntimeError, "Given status in #tick_all or #apply_status does not respond to #modifiers." if !status.respond_to?(:modifiers)
    end

    def warn_about_attributes
      warn("Gave affected_attributes in a Status that are not present on #{self.class.name}: #{invalids}.")
    end

  end

end