# This is meant to represent a child class once Item is inherited from it.
class SurrogateStatus
  attr_accessor :name

  include Adjective::Status
  include Adjective::Statusable

  def initialize(name, args = {})
    @name = name

    initialize_status_data
    initialize_status(args)

  end
end

class SurrogateStatusTwo
  attr_accessor :name, :effect, :power, :description

  include Adjective::Status
  include Adjective::Statusable

  def initialize(name, args = {}, description)
    @name = name
    @effect = :burn
    @power = 3
    @description = description

    initialize_status_data
    initialize_status(args)

  end
end