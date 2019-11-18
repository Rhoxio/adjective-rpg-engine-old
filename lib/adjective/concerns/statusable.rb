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
      @buff_stack = []
      @debuff_stack = []
      self.class.send(:attr_reader, :buff_stack)
      self.class.send(:attr_reader, :debuff_stack)      
    end

    def apply_buff(status, &block)
      affected_attributes = status.affected_attributes
      invalid = affected_attributes.select {|a| !instance_variable_defined?(a) }
      warn_about_attributes if invalid.length > 0
      yield(self) if block_given?
      @buff_stack.push(status)
      return @buff_stack
    end

    def apply_debuff(status, &block)
      affected_attributes = status.affected_attributes
      invalid = affected_attributes.select {|a| !instance_variable_defined?(a) }
      warn_about_attributes if invalid.length > 0
      yield(self) if block_given?
      @debuff_stack.push(status)
      return @debuff_stack
    end

    def tick_buffs

    end

    def tick_debuffs

    end

    private

    def warn_about_attributes
      warn("Gave affected_attributes in a Buff that are not present on #{self.class.name}: #{invalids}. This is normally not an issue, but may expose underlying problems.")
    end

  end

end