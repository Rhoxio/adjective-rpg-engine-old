# This is meant to represent a child class once Item is inherited from it.
class SurrogateItem < Adjective::Item
  attr_accessor :uses, :id, :potency, :ammunition, :pocket

  def initialize(attributes = {})

    # I assume they would override #id in their model somewhere. If not, it tells them to supply it.
    raise RuntimeError, "'#{attribute}' is not present in attributes set: #{attributes}" if !attributes.key?(:id) || !respond_to?(:id)
    @id = self.id ||= attributes[:id]
    @uses = attributes[:uses] ||= 5
    @potency = attributes[:potency] ||= 10
    @ammunition = attributes[:ammunition] ||= 100
    @pocket = ["", ""]
    super(attributes)
  end
end