module Adjective
  class Inventory

    attr_accessor :items, :initialized_at

    def initialize(items = []) 
      validate_incoming_items(items)

      @items = items
      @initialized_at = Time.now
    end

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

    private

    def validate_incoming_items(items)
      return true if items.length === 0

      not_valid = items.any? {|item| item.nil? }
      raise RuntimeError, "Provided item array contains nil values." if not_valid

      return true
    end

  end
end
