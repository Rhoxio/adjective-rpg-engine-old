require 'yaml'

module Adjective

  module GlobalManager

    def self.initialize
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
        load_from_file: true,
        custom_values: {},
        save_on_start: true
      }

      yield(settings) if block_given? 

      if settings[:use_default_settings] && !settings[:load_from_file]
        globals_to_set = settings[:adjective].merge(settings[:custom_values])
        self.load_globals({data: globals_to_set})
        self.save_globals!({data: globals_to_set}) if settings[:save_on_start]
      elsif settings[:use_default_settings] && settings[:load_from_file]
        globals = self.load_globals({
          path: settings[:adjective][:global_file_reference], 
          data: settings[:custom_values]
        })
      end

    end

    def self.load_globals(opts = {})
      globals = Hash.new

      if opts.key?(:data)
        globals.merge!(opts[:data])
      end

      if opts.key?(:path)
        raise RuntimeError, "Please provide a valid file path when loading global variables: #{opts[:path]}" if !File.exist?(opts[:path])

        globals.merge!(YAML.load(File.read(opts[:path]))[:data])

        if ($global_file_reference == globals[:global_file_reference]) && (opts[:path] != globals[:global_file_reference])
          $global_file_reference = opts[:path]
          globals[:global_file_reference] = opts[:path]
        end
        
      end

      yield(globals) if block_given? 

      globals.each {|name, value| eval("$#{name} = #{value.inspect}") }

      return globals
    end

    def self.save_globals!(globals)
      raise RuntimeError, "Please provide a valid file path when saving global variables: #{$global_file_reference}" if !File.exist?($global_file_reference)
      yield(globals) if block_given?
      File.open($global_file_reference, "w"){}
      write_action = File.open($global_file_reference, "w") { |file| file.write(globals.to_yaml) }
      return globals
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


