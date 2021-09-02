class SurrogateFlexible

  attr_accessor :hp

  include Adjective::Aliasable

  def initialize
    @hp = 1

    adj_name_aliases = {
      :hp => :hitpoints,
      :name => :name
    }

    process_aliases(adj_name_aliases)
  end

  def required_attributes
    [:hitpoints, :name]
  end
end