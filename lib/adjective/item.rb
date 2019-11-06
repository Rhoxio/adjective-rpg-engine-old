module Adjective
  class Item
    attr_reader :instance_id, :name, :created_at

    def initialize(params = {})
      @instance_id = nil
      assign_instance_id

      @name = params[:name] ||= ""
      @created_at = Time.now()
    end

    def query_string(scope = :all)
      validate_query_scope(scope)
      chunks = []
      attributes = instance_variables.map {|ivar| ivar.to_s.gsub("@", "").to_sym}
      attributes.each do |attribute|
        attribute_name = attribute.to_s 
        value = send(attribute).to_s
        chunks.push(construct_query_data(attribute_name, value)[scope])
      end
      return chunks.join
    end

    private

    def validate_query_scope(scope)
      raise ArgumentError, "#{Time.now}]: Please provide :full, :attributes, or :values to the scope parameter: given #{scope}" if ![:all, :attributes, :values].include?(scope)
    end    

    def construct_query_data(attribute, item)
      # Delimiting with &: to avoid issues with intermingled data
      return {
        all: attribute + "&:" + item + "&:",
        attributes: attribute + "&:",
        values: item + "&:"
      }
    end      

    def assign_instance_id
      adj_globals = Adjective::GlobalManager.get_globals
      raise RuntimeError, global_not_found if (!adj_globals.key?("item_instance_ref") || $item_instance_ref.nil?)

      @instance_id = adj_globals["item_instance_ref"].to_i
      Adjective::GlobalManager.increment_items
    end

    def global_not_found
      "#{Time.now}]: Could not find global value for #{self.class} in $item_instance_ref= #{$item_instance_ref}. Be sure you have Adjective::GlobalManager.initialize called at least once."
    end
  end
end