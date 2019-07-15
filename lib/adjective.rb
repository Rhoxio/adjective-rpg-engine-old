require 'yaml'

module Adjective

  module GlobalManager

    def self.initialize_globals
      # Adjective-specific variables.
      $item_instance_reference, $actor_instance_reference, $inventory_instance_reference = 0,0,0
      $global_file_reference = 'config/globals.yml'

      settings = {
        adjective: {
          item_instance_reference: $item_instance_reference,
          actor_instance_reference: $actor_instance_reference,
          inventory_instance_reference: $inventory_instance_reference,
          global_file_reference: $global_file_reference
        },
        use_default_settings: true,
        custom_values: {},
        save_on_start: true
      }

      yield(settings) if block_given? 

      if settings[:use_default_settings]
        globals_to_set_and_save = settings[:adjective].merge(settings[:custom_values])
        self.load_globals({raw_data: globals_to_set_and_save})
        self.save_globals!({raw_data: globals_to_set_and_save}) if settings[:save_on_start]
      end

    end

    def self.load_globals(opts = {})
      if opts.key?(:raw_data)
        globals = opts[:raw_data]
      elsif opts.key?(:path)
        raise RuntimeError, "Please provide a valid file path when loading global variables: #{opts[:path]}" if !File.exist?(opts[:path])
        globals = YAML.load(File.read(opts[:path]))
      else
        globals = {}
      end

      yield(globals) if block_given? 

      globals.each do |name, value|
        eval("$#{name} = #{value.inspect}")
      end

      return globals
    end

    def self.save_globals!(globals)

      if !$global_file_reference.nil?
        yield(globals) if block_given? 
        globals = File.open($global_file_reference, "w") { |file| file.write(globals.to_yaml) }
      end

      return !!globals
    end

    def self.clear_globals!
      # Write and clear varible values from YML file. 
    end

    def self.view_globals
      # See all k/v pairs from 
    end

  end

end

Dir[File.join(__dir__, 'adjective', '*.rb')].each { |file| require file }


