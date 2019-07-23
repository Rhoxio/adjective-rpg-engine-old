require 'yaml'

module Adjective

  module GlobalManager

    def self.initialize
      # Adjective-specific variables.
      $item_instance_reference = 0
      $actor_instance_reference = 0
      $inventory_instance_reference = 0
      @@globals = []

      settings = {
        adjective: {
          item_instance_reference: $item_instance_reference,
          actor_instance_reference: $actor_instance_reference,
          inventory_instance_reference: $inventory_instance_reference,
        },
        custom_values: {}
      }

      yield(settings) if block_given? 

      globals_to_set = settings[:adjective].merge(settings[:custom_values])
      self.load_globals({data: globals_to_set})

    end

    def self.load_globals(opts = {})
      globals = Hash.new
      globals.merge!(opts[:data]) if opts.key?(:data)
      yield(globals) if block_given? 

      globals.each do |name, value| 
        eval("$#{name} = #{value.inspect}")
        @@globals.push("#{name}")
      end
      return globals
    end

    def self.keys
      @@globals
    end

    def self.clear_globals!
      @@globals = []
      return true 
    end

    def self.view_globals
      return_value = {}
      @@globals.each do |var|
        return_value[var] = "#{eval "$#{var}.inspect"}"
      end
      return return_value
    end

  end

end

Dir[File.join(__dir__, 'adjective', '*.rb')].each { |file| require file }


