class Inventory
  attr_reader :items

  def initialize(items = [])
    # Must take an initial payload of items. 
    @items = items

  end

  # def sort_by(attribute)
  #   # Taken as a symbol...

  #   @items = @items
  # end

  # This system is meant to be able to take in arrays of items and return 
  # different imformation about the collection of objects. This may end up being primarily utility
  # methods to ease common uses for the inventory. 

  # I am going to assume that they are using a class to represent their items
  # and that it will either a) be the Item class from this work or
  # their own custom-defined attribute on a child class. 

  # 1. Needs to handle lists of ambiguous data and return sorted data.
  # 2. Needs to be able to filter lists of ambiguous data by attribute.
  # 3. Needs to be able to insert/pop/shift items.
  # 4. Needs to be able to increment/decrement/set number of Items.
  # 5. Needs to have flexibility for limited/unlimited slots.

end