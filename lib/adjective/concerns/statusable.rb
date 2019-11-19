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
      @buffs = []
      @debuffs = []
      self.class.send(:attr_reader, :buffs)
      self.class.send(:attr_reader, :debuffs)      
    end

    def apply_buff(status, &block)
      affected_attributes = status.affected_attributes
      check_attributes(affected_attributes)
      yield(self) if block_given?
      @buffs.push(status)
      return @buffs
    end

    def apply_debuff(status, &block)
      affected_attributes = status.affected_attributes
      check_attributes(affected_attributes)
      yield(self) if block_given?
      @debuffs.push(status)
      return @debuffs
    end

    def tick_buffs

    end

    def tick_debuffs

    end

    def tick_all(first = :buffs)

    end

    private

    def check_attributes(affected_attributes)
      invalid = affected_attributes.select {|att| !instance_variable_defined?(att) }
      warn_about_attributes if invalid.length > 0
    end

    def warn_about_attributes
      warn("Gave affected_attributes in a Status that are not present on #{self.class.name}: #{invalids}. This may expose underlying problems and explain errant functionality.")
    end

  end

end