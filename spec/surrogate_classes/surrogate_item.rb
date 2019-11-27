# This is meant to represent a child class once Item is inherited from it.
class SurrogateItem
  attr_accessor :uses, :id, :potency, :ammunition, :pocket, :name, :created_at

  def initialize(attributes = {})

    # I assume they would override #id in their model somewhere. If not, it tells them to supply it.
    @id = self.id ||= attributes[:id]
    @name = attributes[:name] ||= ""
    @uses = attributes[:uses] ||= 5
    @potency = attributes[:potency] ||= 10
    @ammunition = attributes[:ammunition] ||= 100
    @pocket = ["", ""]
    @created_at = Time.now
    # super(attributes)
  end
end