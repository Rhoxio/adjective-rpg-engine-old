module Adjective
  class Item
    attr_reader :instance_id, :name

    def initialize(params)
      raise RuntimeError, "No :instance_id parameter specified." if !params.key?(:instance_id)
      @instance_id = params[:instance_id]
      @name = params[:name] ||= ""
    end
  end
end