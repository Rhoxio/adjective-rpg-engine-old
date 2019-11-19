# This is a potentially nested inventory type of system. 
class SurrogateInventory
  attr_reader :name, :id

  include Adjective::Storable

  def initialize(name = "", id = 2 , items = [], opts = {})
    @id = id
    @name = name

    initialize_storage_data(items, opts)
  end

  def sort
    @items.sort_by { |item| item.name }
  end
end