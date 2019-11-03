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

    # Simple Search
    def query(term)
      matching_objects = []
      @items.each do |item|
        attributes = item.instance_variables.map {|ivar| ivar.to_s.gsub("@", "").to_sym}
        attributes.each do |attribute|
          # to_s works on most object types and is easy to check substrings against
          # Can potentially use it to find by similar attribute names in different item sets.
          data = item.send(attribute).to_s
          matching_objects << item if data.include?(term)
        end
      end
      return matching_objects
    end     

    # Store - Put
    def store(items)
      Array(items).each do |item|
        @items << item
      end
    end

    # Retrieval - Get
    def retrieve(instance_id)
      @items.find {|item| item.instance_id == instance_id }
    end

    def retrieve_by(attribute, value)
      @items.select do |item| 
        item if item.respond_to?(attribute) && item.send(attribute) === value 
      end      
    end

    # Dump - Delete all
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
      @items.sort_by { |item| item.created_at }
    end

    def sort!
      @items = @items.sort_by { |item| item.created_at }
    end    

    def sort_by(attribute, order = :asc)
      validate_sort_direction(order)
      validate_attribute(attribute)
      sorted = @items.sort_by(&attribute)
      return order == :asc ? sorted : sorted.reverse
    end

    def sort_by!(attribute, order = :asc)
      validate_sort_direction(order)
      validate_attribute(attribute)
      sorted = @items.sort_by(&attribute)
      return order == :asc ? @items = sorted : @items = sorted.reverse
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
