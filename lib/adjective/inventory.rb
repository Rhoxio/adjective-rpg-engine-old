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
      # Should only return one object.
      
    end

    def get_by(attribute, value = nil)
      # results = []
      # ap attribute
      # ap value
      # @items.each do |item|
      #   ap item.respond_to?(attribute)
      #   ap item.name
      #   if item.respond_to?(attribute)
      #     ap 'responds to it'
      #     attribute = item.send(attribute)
      #     ap attribute
      #     if value.nil?
      #       ap 'NIL'
      #       results << item
      #     elsif attribute == value && !value.nil?
      #       ap "NN"
      #       results << item
      #     end
      #   end
      # end
      # return results
    end    

    def store(item)
      # Put functionality
    end

    def deposit(items)
      # alias for #put
    end

    def dump
      outbound_items = @items
      @items = []
      return outbound_items
    end

    def dump_until(index)
      # Will clear inventory until a specific index and return the items
    end

    def dump_by!(attribute, value)
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

    def remove

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
      results = []
      item_attrs.each do |item_name, data|
        data.each do |datum|
          if datum.include?(term.downcase)
            results << get_by(:name, item_name)
          end
        end
      end
      return results
    end

    private

    def item_attrs
      vars = {}
      @items.map do |item| 
        if !vars.key?(item.name)
          vars[item.name] = item.instance_variables.map {|ivar| item.instance_variable_get(ivar).to_s.downcase }
        end
      end
      return vars.each {|ary| ary.flatten! }
    end

    def validate_incoming_items(items)
      return true if items.length === 0

      not_valid = items.any? {|item| item.nil? }
      raise RuntimeError, "Provided item array contains nil values." if not_valid

      return true
    end

  end
end
