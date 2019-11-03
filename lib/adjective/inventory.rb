module Adjective

  class Inventory

    attr_reader :initialized_at
    attr_accessor :items

    def initialize(items = [], opts= {}) 

      @items = items
      @initialized_at = Time.now

      # @is_limited = opts[:limit_space] ||= 
    end

    def empty?
      @items.length === 0
    end    

    def store(items)
      new_items = Array(items)
      new_items.each do |item|
        @items << item
      end
    end

    def retrieve(instance_id)
      item = @items.find {|item| item.instance_id == instance_id }
      return item
    end

    def retrieve_by(attribute, value)
      matches = []
      @items.each_with_index do |item, index| 
        if item.respond_to?(attribute) && item.send(attribute) === value 
          matches.push(item)
        end
      end      
      return matches
    end

    def dump
      outbound_items = @items
      @items = []
      return outbound_items
    end

    def dump_by(attribute, value)
      outbound_items = retrieve_by(attribute, value)
      @items = @items.select {|item| !outbound_items.include?(item) }
      return outbound_items
    end    

    def sort
      return @items.sort_by { |item| item.created_at }
    end

    def sort!
      @items = @items.sort_by { |item| item.created_at }
      return @items
    end    

    def sort_by(attribute, order = :asc)
      validate_attribute(attribute)
      sorted = @items.sort_by(&attribute)
      if order == :asc
        return sorted
      else
        return sorted.reverse
      end
    end

    def sort_by!(attribute, order = :asc)
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
      raise RuntimeError, "#{attribute} is not present on an item set: #{@items}" if @items.any? {|item| !item.respond_to?(attribute)} 
    end

  end
end
