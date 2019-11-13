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
  module Imbibable

    def initialize_experience(table, initial_exp = 0)
      @experience = initial_exp
      @active_exp_set = table
      # p table
      self.class.send(:attr_reader, :experience)
      self.class.send(:attr_reader, :active_exp_set)
    end

  end

end