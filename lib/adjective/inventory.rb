module Adjective
  class Inventory

    attr_accessor :items, :initialized_at

    def initialize(items = [], opts = {}) 
      validate_incoming_items(items)

      @items = items
      @initialized_at = Time.now

      # @is_limited = opts[:limit_space] ||= 
    end

    # Sorting Utilities

    def sort
      return @items.sort_by { |item| item.created_at }
    end

    def sort!
      @items = @items.sort_by { |item| item.created_at }
      return @items
    end    

    def sort_by(attribute, order = :asc)
      raise RuntimeError, "#{attribute} is not present on an item set: #{@items}" if items.any? {|item| !item.respond_to?(attribute)} 
      if order == :asc
        return @items.sort_by(&attribute)
      else
        return @items.sort_by(&attribute).reverse
      end
    end

    def sort_by!(attribute, order = :asc)
      raise RuntimeError, "#{attribute} is not present on an item set: #{@items}" if items.any? {|item| !item.respond_to?(attribute)} 
      if order == :asc
        @items = @items.sort_by(&attribute)
      else
        @items = @items.sort_by(&attribute).reverse
      end
      return @items
    end

    # Inventory Management

    def empty?
      @items.length === 0
    end

    def get(instance_id)
      # Fetch functionality
      # This will cover the unique identifier 
    end

    def get_by(attribute, value)
      # Specific fetch functionality
    end    

    def put(item)
      # Put functionality
    end

    def post(items)
      # post functionality
    end

    def deposit
      # alias for #put
    end

    def dump!
      # clears the whole inventory and returns the items
    end
    

    def dump_up_to!(index)
      # Will clear inventory until a specific index and return the items
    end

    def dump_by!(attribute, value)
      # find_by block,
      matching_indices = []
      @items.each_with_index do |item, index| 
        if item.respond_to?(attribute) && item.send(attribute) === value 
          matching_indices.push(index)
        end
      end

      outbound_items = matching_indices.map {|index| @items[index]}
      @items = @items.select.with_index {|item, index| !matching_indices.include?(index) }

      return outbound_items

    end

    def remove()

    end

    def delete

    end

    # Reporting Utilities

    def data
      # Will return data about the inventory. 
      # This will include: 
    end

    def query(term)
      # Scan utility to check for string matches within item attributes.
    end

    private

    def validate_incoming_items(items)
      return true if items.length === 0

      not_valid = items.any? {|item| item.nil? }
      raise RuntimeError, "Provided item array contains nil values." if not_valid

      return true
    end

  end
end
