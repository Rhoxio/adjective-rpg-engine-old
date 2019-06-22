module Adjective
  class Item
    attr_reader :instance_id, :name, :created_at

    def initialize(params)
      raise RuntimeError, "No :instance_id parameter specified." if !params.key?(:instance_id)
      @instance_id = params[:instance_id]
      @name = params[:name] ||= ""

      @created_at = Time.now()
    end
  end
end