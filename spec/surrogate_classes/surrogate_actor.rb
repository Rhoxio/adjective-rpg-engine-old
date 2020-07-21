class SurrogateActor
  attr_accessor :gender, :name, :badly_poisoned, :crit_multiplier

  include Adjective::Statusable
  include Adjective::Imbibable
  include Adjective::Vulnerable

  def initialize(name, opts = {})
    @name = name
    @gender = opts[:gender] ||= "female"
    @badly_poisoned = false

    # Should be controlled with more finesse in combatable or something.
    @baseline_crit_multiplier = 2.0
    @crit_multiplier = @baseline_crit_multiplier

    # From Statusable
    initialize_status_data
    # From Imbibable
    initialize_experience(opts)
    # From Vulerable
    initialize_vulnerability(1, 10)
  end
end