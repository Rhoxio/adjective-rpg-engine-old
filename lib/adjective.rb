require 'yaml'

module Adjective

  module GlobalManager

    def self.initialize
      # Adjective-specific variables.
      $item_instance_ref = 1
      $actor_instance_ref = 1
      $inventory_instance_ref = 1
      @@globals = []


      settings = {
        adjective: {
          item_instance_ref: $item_instance_ref,
          actor_instance_ref: $actor_instance_ref,
          inventory_instance_ref: $inventory_instance_ref,
        },
        custom: {}
      }

      # 'settings' passed here for load in initialization file
      yield(settings) if block_given? 

      globals_to_set = settings[:adjective].merge(settings[:custom])
      self.load_globals({data: globals_to_set})

    end

    def self.load_globals(opts = {})
      globals = Hash.new
      globals.merge!(opts[:data]) if opts.key?(:data)
      yield(globals) if block_given? 

      globals.each do |name, value| 
        eval("$#{name} = #{value}")
        @@globals.push("#{name}")
        @@globals.uniq!
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

    def self.get_globals
      return_value = {}
      @@globals.each do |var|
        return_value[var] = "#{eval "$#{var}.inspect"}"
      end
      return return_value
    end

    def self.increment_items
      $item_instance_ref += 1
    end

    def self.increment_actors
      $actor_instance_ref += 1
    end

    def self.increment_inventories
      $inventory_instance_ref += 1
    end    

  end

end

Dir[File.join(__dir__, 'adjective', '*.rb')].each { |file| require file }


