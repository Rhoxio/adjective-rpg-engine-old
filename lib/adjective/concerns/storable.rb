module Adjective

  module Storable

    def initialize_storage_data(items = [], opts = {})
      @items = items
      @initialized_at = Time.now
      @max_size = opts[:max_size] ||= :unlimited
      @default_sort_method = opts[:default_sort_method] ||= :object_id
      validate_inventory_capacity
      [:items, :initialized_at, :max_size, :default_sort_method].each {|attribute| self.class.send(:attr_accessor, attribute) }
    end

    # Utility Methods
    def empty?
      @items.length === 0
    end   

    def full?
      @max_size == :unlimited ? false : @items.length < @max_size
    end

    def can_store?(items)
      return true if @max_size == :unlimited
      return true if (Array(items).length + @items.length) <= @max_size
      return false
    end

    def empty_slots
      @max_size == :unlimited ? :unlimited : @max_size - @items.length
    end

    # Simple Search
    # options for scope are: :all, :attributes, :values
    def query(term, scope = :all)
      validate_query_scope(scope)
      matches = []
      @items.each do |item|
        chunks = []
        attributes = item.instance_variables.map {|ivar| ivar.to_s.gsub("@", "").to_sym}
        attributes.each do |attribute|
          chunks.push(construct_query_data(attribute.to_s, item.public_send(attribute).to_s)[scope])
        end
        matches << item if chunks.join.include?(term)
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

    # retrieve_by - Get
    def retrieve_by(attribute, value)
      @items.select do |item| 
        item if item.respond_to?(attribute) && item.public_send(attribute) === value 
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
      @items.sort_by { |item| item.public_send(@default_sort_method) }
      return @items
    end

    def sort!
      @items = @items.sort_by { |item| item.public_send(@default_sort_method) }
      return @items
    end    

    def sort_by(attribute, order = :asc)
      sorted = @items.sort_by(&attribute)
      return order == :asc ? sorted : sorted.reverse
    end

    def sort_by!(attribute, order = :asc)
      sorted = @items.sort_by(&attribute)
      return order == :asc ? @items = sorted : @items = sorted.reverse
    end

    alias_method :deposit, :store
    alias_method :put, :store  
    alias_method :get_by, :retrieve_by
    alias_method :find_by, :retrieve_by        
    alias_method :clear, :dump
    alias_method :clear_by, :dump_by
    alias_method :search, :query

    private  

    def validate_query_scope(scope)
      raise ArgumentError, "[#{Time.now}]: Please provide :full, :attributes, or :values to the scope parameter: given #{scope}" if ![:all, :attributes, :values].include?(scope)
    end

    def construct_query_data(attribute, val)
      # Delimiting with &: to avoid issues with intermingled data
      return {
        all: attribute + "&:" + val + "&:",
        attributes: attribute + "&:",
        values: val + "&:"
      }
    end      

    def validate_inventory_capacity
      return true if @max_size == :unlimited
      total_length = @items.length
      raise ArgumentError, "#{Time.now}]: items argument length larger than max size: max_size: #{@max_size}, items_length: #{total_length}" if total_length > @max_size   
    end

  end

end
