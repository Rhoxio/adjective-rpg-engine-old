class Item
  attr_reader :id, :name

  def initialize(params)
    raise RuntimeError, "No :id parameter specified." if !params.key?(:id)
    @id = params[:id]
    @name = params[:name] ||= ""
  end
end