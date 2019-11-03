module Adjective

  class Inventory

    attr_reader :initialized_at
    attr_accessor :items

    def initialize(items = [], opts= {}) 

      @items = items
      @initialized_at = Time.now
    end

    def empty?
      @items.length === 0
    end    


    # Store - Put
    def store(items)
      new_items = Array(items)
      new_items.each do |item|
        @items << item
      end
    end

    # Retrieval - Get
    def retrieve(instance_id)
      item = @items.find {|item| item.instance_id == instance_id }
      return item
    end

    def retrieve_by(attribute, value)
      matches = @items.select do |item| 
        item if item.respond_to?(attribute) && item.send(attribute) === value 
      end      
      return matches
    end


    # Dump - Delete
    def dump
      outbound_items = @items
      @items = []
      return outbound_items
    end

    # dump_by - Selective delete
    def dump_by(attribute, value)
      outbound_items = retrieve_by(attribute, value)
      @items = @items.select {|item| !outbound_items.include?(item) }
      return outbound_items
    end    

    # Sorting
    def sort
      return @items.sort_by { |item| item.created_at }
    end

    def sort!
      @items = @items.sort_by { |item| item.created_at }
    end    

    def sort_by(attribute, order = :asc)
      validate_sort_direction(order)
      validate_attribute(attribute)
      sorted = @items.sort_by(&attribute)
      if order == :asc
        return sorted
      else
        return sorted.reverse
      end
    end

    def sort_by!(attribute, order = :asc)
      validate_sort_direction(order)
      validate_attribute(attribute)
      sorted = @items.sort_by(&attribute)
      if order == :asc
        @items = sorted
      else
        @items = sorted.reverse
      end
      return @items
    end

    private

    def validate_attribute(attribute)
      raise RuntimeError, "#{attribute} is not present on an item in set: #{@items}" if @items.any? {|item| !item.respond_to?(attribute)} 
    end

    def validate_sort_direction(order)
      raise ArgumentError, "order paraamter must be :asc or :desc" if ![:asc, :desc].include?(order)
    end

  end
end
