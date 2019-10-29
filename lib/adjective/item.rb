module Adjective
  class Item
    attr_reader :instance_id, :name, :created_at

    def initialize(params = {})
      @instance_id = nil
      assign_instance_id

      @name = params[:name] ||= ""
      @created_at = Time.now()
    end

    private

    def assign_instance_id
      adj_globals = Adjective::GlobalManager.get_globals
      raise RuntimeError, global_not_found if (!adj_globals.key?("item_instance_ref") || $item_instance_ref.nil?)

      @instance_id = adj_globals["item_instance_ref"].to_i
      Adjective::GlobalManager.increment_items
    end

    def global_not_found
      "Could not find global value for #{self.class} in $item_instance_ref= #{$item_instance_ref}. Be sure you have Adjective::GlobalManager.initialize called at least once."
    end
  end
end