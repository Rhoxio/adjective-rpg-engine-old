require 'yaml'
require_relative './table.rb'

class Actor
  attr_accessor :name, :hitpoints, :experience, :level
  attr_reader :exp_table

  def initialize(name, params = {})
    # Default values
    @name = name
    @hitpoints = 1
    @experience = 0
    @level = 1
    @exp_table = params[:exp_table].data

    # Params that take actual input and flexibility for other attributes.
    # These will override the ones defined above if passed through in params.
    # ** NOT TESTED YET. GETTING the filesystem reads and base functionality finished first.**
    params.each do |key, value|
      instance_variable_set("@#{key}", value)
    end    

    # For extra initialization code later.
    # yield block if block
  end

  def level_up
    # This is going to be based on a table lookup for exp values in a separate file.
  end

  def take_damage(damage)
    @hitpoints -= damage
    normalize_hitpoints

    return self
  end

  def alive?
    @hitpoints > 0
  end

  def dead?
    @hitpoints == 0
  end

  private 

  # The reason for setting this up so actors can not go below 0 hp is
  # primarily to ensure consistency to preemptively ensure that healing 
  # abilities are not having to be edge-cased out if they are at 0 hitpoints.
  # I may change this if I can think of particular use-cases. 

  # I can see special types of attacks bringing an actor below 0 until they are resurrected with
  # a specific type of ability, but would probably best be handled by a Status of 'grievous injury' or
  # 'decimated' or something like that. That would require a check further up the chain in the 
  def normalize_hitpoints
    if @hitpoints < 0
      @hitpoints = 0
    end
  end

end

exp_table = Table.new('config/exp_table.yml', 'main')
# p exp_table.file
actor = Actor.new("Mike", { exp_table: exp_table })




