module Adjective
  module Aliasable

    # adj_name_aliases = {
    #   :hp => :hitpoints,
    #   :name => :name
    # }

    def validate_aliasable_attributes(aliases)
      failed_aliases = []
      aliases.each do |origin, adj_attribute|
        failed_aliases.push(adj_attribute) if !self.respond_to?(adj_attribute)
        failed_aliases.push(origin) if !self.respond_to?(origin) 
      end
      raise NoMethodError, "Could not set aliases for: #{failed_aliases}. Ensure that the origin class can respond_to each of them." if !failed_aliases.empty?
    end

    def establish_aliases
      aliases = @__adj_new_aliases

      
      # aliases[:getters].each do |origin, adj_attribute|
      #   alias adj_attribute origin
      # end
      # aliases[:setters].each do |origin, adj_attribute|
      #   alias :"#{adj_attribute}=" origin
      # end
    end

    # I think the idea is to be able to translate certain attributes in their own code over to the adjective-acceptable versions
    # that are set on module initialization.

    # It should allow for the library to use other instance variables when making its calculations. If the AR method
    # 'name' is called, it would use the 'name' getter from the origin class instead. 

    # Will need to set up acceptable_aliases structure in each class to ensure that things get set correctly
    def process_aliases(aliases)
      getter_aliases = {}
      setter_aliases = {}
      validate_aliasable_attributes(aliases)

      # If an alias doesnt exist but is required to exist for the class to function,
      # check the required_aliases method on the class and fill in k/v pairs by default.

      aliases.each do |origin, adj_attribute|

        has_getter = self.respond_to?(origin)
        has_setter = self.respond_to?(origin.to_s+"=")

        has_no_setter = has_getter && !has_setter
        has_no_getter = !has_getter && has_setter

        has_getter_and_setter = has_getter && has_setter
        has_no_getter_and_setter = has_no_getter && has_no_setter

        if has_getter_and_setter
          getter_aliases[origin] = adj_attribute
          setter_aliases[origin] = adj_attribute
        elsif has_getter && has_no_setter
          getter_aliases[origin] = adj_attribute
        elsif has_no_getter && has_setter
          setter_aliases[origin] = adj_attribute
        end
      end

      return {getters: getter_aliases, setters: setter_aliases}
    end

  end
end