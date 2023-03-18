class SurrogateFlexible

  attr_accessor :hp, :max_hp
  attr_reader :__adj_aliases, :__adj_new_aliases

  include Adjective::Vulnerable
  include Adjective::Aliasable

  def initialize(given_aliases)
    @__adj_aliases = given_aliases
    initialize_vulnerability(1, 10)
    @hp = 1
    @max_hp = 10

    @__adj_new_aliases = process_aliases(@__adj_aliases)
    establish_aliases

  end

end