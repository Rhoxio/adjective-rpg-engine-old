module Adjective
  module Aliasable

    # I think the idea is to be able to translate certain attributes in their own code over to the adjective-acceptable versions
    # that are set on module initialization.

    # It should allow for the library to use other instance variables when making its calculations. If the AR method
    # 'name' is called, it would use the 'name' getter from the origin class instead. 

    # Take in set of values and check for getters and setters
    #   if setters/getters exist for given alias, use those methods
    #   else, establish getters and setters using instance variables passed in through args

    # examples would be:
    #   {hitpoints: :hp}
    #   {hitpoints: :hitpoints}

    # Will need to set up acceptable_aliases structure in each class to ensure that things get set correctly
    def process_aliases(aliases)
      finalized_aliases = {}

      # If an alias doesnt exist but is required to exist for the class to function,
      # check the required_aliases method on the class and fill in k/v pairs by default.

      raise NoMethodError, "'required_attributes' not present on class #{self.class.name}. This is required for attribute assignment." if !self.class.respond_to?(:required_attributes)

      aliases.each do |origin, adj_attribute|

        has_getter = self.respond_to?(origin)
        has_setter = self.respond_to?(origin.to_s+"=")

        has_no_setter = has_getter && !has_setter
        has_no_getter = !has_getter && has_setter

        has_getter_and_setter = has_getter && has_setter
        has_no_getter_and_setter = has_no_getter && has_no_setter

        # ap [has_setter, has_getter]

        if has_getter_and_setter
          # Leave it alone and alias the original provided one to the adj_attribute for internal consumption
          finalized_aliases[origin] = adj_attribute
        elsif has_no_getter_and_setter
          # There is no structure defined on the class for it. Direct alias and assignment of accessors is required.
          finalized_aliases[adj_attribute] = adj_attribute
        end

        # If it has no setter or getter, set it to alias to itself
        # finalized_aliases[adj_attribute] = adj_attribute if !has_getter && !has_setter

        # 

        # ap finalized_aliases

      end
    end

  end
end