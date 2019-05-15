require 'yaml'
require_relative './table.rb'

class Actor
  attr_accessor :name, :hitpoints, :experience, :level
  attr_reader :exp_table, :exp_table_name

  def initialize(name, params = {})

    # Default values
    @name = name
    @hitpoints = 1
    @experience = 0
    @level = 1

    # Params that take actual input and flexibility for other attributes.
    # These will override the ones defined above if passed through in params.
    params.each do |key, value|
      instance_variable_set("@#{key}", value)
    end

    @exp_table_name = params.key?(:exp_table_name) ? params[:exp_table_name] : "main"
    @exp_table = params[:exp_table].data[@exp_table_name]

    # For extra initialization code later.
    # yield block if block
  end

  def can_level_up?
    @experience >= @exp_table[@level]
  end  

  def level_up_to(num)
    # Will grant levels and set the experience value to that level's requirements.
    # return amended self
  end

  def grant_levels(num, opts = {})
    @level += num
    if !opts[:constrain_exp] 
      @experience = @exp_table[@level]
    end
  end 

  def level_up!
    if can_level_up?
      @level += 1
      return true
    else
      return false
    end
  end

  def experience_to_next_level
    # Difference between next level and current one.
  end

  def grant_experience(exp_to_grant)
    # Only takes positive integers. 
    if exp_to_grant < 0
      raise RuntimeError, "Provided value in grant_experience (#{exp_to_grant}) is not a positive integer."
    else
      @experience += exp_to_grant
    end   
  end

  def subtract_experience(exp)

  end

  def set_experience_table(name)
    # Will swap one exp table to another.
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
  # 'decimated' or something like that. That would require a check further up the chain before damage is actually dealt..
  def normalize_hitpoints
    @hitpoints = 0 if @hitpoints < 0
  end

end

exp_table = Table.new('config/exp_table.yml', 'main')
# p exp_table.file
actor = Actor.new("Mike", { exp_table: exp_table })




