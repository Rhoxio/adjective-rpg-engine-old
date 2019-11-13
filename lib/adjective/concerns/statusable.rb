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
    end

    def apply_buff(status, &block)
      affected_attributes = status.affected_attributes.map{|a| ("@"+a.to_s).to_sym }
      invalids = affected_attributes.select {|a| !instance_variable_defined?(a) }
      raise RuntimeError, "Attempted to apply buff to model that does not have instance variables of: #{invalids}" if invalids.length > 0

      @buff_stack.push(status)
      # Will only apply the buff if the appropriate attribute
      # is present.
      yield(self) if block_given?
    end

    def apply_debuff

    end

    def tick_buffs

    end

    def tick_debuffs

    end

    def validate_response

    end

  end

end