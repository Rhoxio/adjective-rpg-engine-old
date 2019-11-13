# This is a potentially nested inventory type of system. 
class SurrogateInventory < Adjective::Inventory
  attr_reader :name, :id
  attr_reader :pocket

  def initialize(name, id, items = [])
    @id = id
    @name = name
    super(items)
  end

  def sort
    @items.sort_by { |item| item.name }
  end
end