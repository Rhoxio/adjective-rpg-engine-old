class SurrogateActor < Adjective::Actor
  attr_reader :gender, :name

  include Adjective::Statusable
  include Adjective::Imbibable

  def initialize(name, opts = {})
    @name = name
    @gender = opts[:gender] ||= "female"
    super(name, opts)

    # From Statusable
    initialize_status_data
    # From Imbibable
    initialize_experience(opts)    
  end
end