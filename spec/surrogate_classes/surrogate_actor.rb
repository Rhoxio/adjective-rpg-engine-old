class SurrogateActor
  attr_accessor :gender, :name

  include Adjective::Statusable
  include Adjective::Imbibable
  include Adjective::Vulnerable

  def initialize(name, opts = {})
    @name = name
    @gender = opts[:gender] ||= "female"

    # From Statusable
    initialize_status_data
    # From Imbibable
    initialize_experience(opts)
    # From Vulerable
    initialize_vulnerability(1, 10)
  end
end