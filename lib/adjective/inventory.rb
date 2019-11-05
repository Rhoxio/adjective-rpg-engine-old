module Adjective

  class Inventory

    attr_reader :initialized_at, :max_size
    attr_accessor :items

    def initialize(items = [], opts = {}) 
      @items = items
      @initialized_at = Time.now
      @max_size = opts[:max_size] ||= :unlimited
      validate_inventory_capacity
    end

    def empty?
      @items.length === 0
    end   

    def full?
      @max_size == :unlimited ? false : @items.length < @max_size
    end

    def can_store?(items)
      return true if @max_size == :unlimited
      p (Array(items).length + @items.length) >= @max_size
      return true if (Array(items).length + @items.length) >= @max_size
      return false
    end

    # Simple Search
    # options for scope are: :all, :attributes, :values
    def query(term, scope = :all)
      matches = []
      @items.each do |item|
        matches << item if item.query_string(scope).include?(term)
      end
      return matches
    end     

    # Store - Put
    def store(items)
      if can_store?(items)
        Array(items).each do |item|
          @items << item 
        end
        return items
      else
        return false
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

    # Dump selection - Selective delete
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

    def validate_inventory_capacity
      return true if @max_size == :unlimited
      raise ArgumentError, "#{Time.now}]: items argument length larger than max size: max_size: #{@max_size}, items_length: #{@items.length}" if @items.length > @max_size   
    end

    def validate_attribute(attribute)
      raise RuntimeError, "#{Time.now}]: #{attribute} is not present on an object " if @items.any? {|item| !item.respond_to?(attribute) } 
    end

    def validate_sort_direction(order)
      raise ArgumentError, "#{Time.now}]: argument 'order' parameter must be :asc or :desc" if ![:asc, :desc].include?(order)
    end

  end
end
