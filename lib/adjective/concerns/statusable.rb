module Adjective

  # I plan on having this module handle the messier side of handling buff/debuff processing
  # It will need to include a way to manage the coupling between Status and the target model.
  # It will need to be able to process and return values that can be easily passed into other
  # methods. 

  # This means that it should only know about:
  # Static: duration, remaining
  # Dynamic: attributes to amend on the thing being 'statused'.
  # 
  # And should retain internal variables of:
  # Static: application_time
  # 
  module Statusable

    def initialize_status_data
      @statuses = []
      self.class.send(:attr_accessor, :buffs)
      self.class.send(:attr_accessor, :debuffs)      
    end

    def apply_status(status, &block)
      validate_modifier_existence(status)
      affected_attributes = status.affected_attributes
      check_attributes(affected_attributes)
      yield(self, status) if block_given?
      @statuses.push(status)
      return @statuses
    end

    def tick_all(&block)
      @statuses.each do |status|
        validate_modifier_existence(status)
        status.modifiers.each do |key, value|
          attribute = key.to_s
          eval("self.#{attribute} += #{value}") if self.respond_to?(attribute+"=")
        end
      end
      yield(self, @statuses) if block_given?
      return @statuses
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