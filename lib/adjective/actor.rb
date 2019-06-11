require 'yaml'
require_relative './table.rb'

module Adjective
  class Actor
    attr_accessor :name, :hitpoints, :experience, :level
    attr_reader :exp_sets, :exp_set_name, :active_exp_set

    def initialize(name, params = {})

      # Default values
      @name = name
      @hitpoints = 1
      @experience = 0
      @level = 1

      params.each do |key, value|
        self.instance_variable_set("@#{key}", value) if (!exp_table_exceptions.include?(key) || initial_attributes.include?(key))
      end

      # May eventually implement a way to directly override the exp table used with a simple array. 
      # Will have to see if use-cases some up or not.

      @exp_sets = params[:exp_sets]
      @exp_set_name = params.key?(:exp_set_name) ? params[:exp_set_name] : "main"
      @active_exp_set = params[:exp_sets].data[@exp_set_name]

      # yield block if block
    end

    def can_level_up?
      @experience >= @active_exp_set[@level]
    end  

    def set_level(num, opts = {})
      @level = num
      @experience = @active_exp_set[num] if !opts[:constrain_exp]
    end

    def grant_levels(num, opts = {})
      @level += num
      @experience = @active_exp_set[@level] if !opts[:constrain_exp] 
    end 

    def level_up!
      if can_level_up?
        @level += 1
        return true
      else
        return false
      end
    end

    def level_down!
      if experience < @active_exp_set[@level]
        @level -=1
        return true
      else
        return false
      end
    end

    def experience_to_next_level
      if @active_exp_set.length == @level
        # They are max level.
        return 0
      elsif @active_exp_set.length < (@level+1)
        raise RangeError, "Next level out of experience table range from 0 to #{@active_exp_set.length}, (#{@level+1})"
      else
        return @active_exp_set[@level+1] - @active_exp_set[@level]
      end
    end

    def grant_experience(exp_to_grant, opts = {})
      # Only takes positive integers - should avoid bugs this way.
      if exp_to_grant < 0
        raise RuntimeError, "Provided value in #grant_experience (#{exp_to_grant}) is not a positive integer."
      else
        @experience += exp_to_grant
        normalize_experience

        # This has a weaness in that it will always count over 
        if !opts[:suppress_levels]
          until !can_level_up?
            level_up!
          end
        end

        return { :exp_granted => exp_to_grant, :total_exp => @experience }
      end   
    end

    def subtract_experience(exp_to_subtract, opts = {})
      # Only takes positive integers - should avoid bugs this way. 
      if exp_to_subtract < 0
        raise RuntimeError, "Provided value in #subtract_experience (#{exp_to_subtract}) is not a positive integer."
      else
        @experience -= exp_to_subtract
        normalize_experience

        if !opts[:suppress_levels]
          until !level_down!
            level_down!
          end
        end

      end 
    end

    def use_experience_set(name)
      # This is going to swap around the table pulled from, not the file it is pulled from explicitly.
      if @exp_sets.set_exists?(name)
        @exp_set_name = name
        @active_exp_set = @exp_sets.data[name]
        return true
      else
        raise ArgumentError, "The provided set name was not found: #{name}"
      end
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

    # Ended up foregoing this solution as these classes need to be directly inheritable from. 
    # They are not meant to be the base class to be worked against and directly amended.

    # def add_attribute(name, value)
    #   if !instance_variable_defined?("@#{name}")
    #     instance_variable_set("@#{name}", value)
    #     define_singleton_method("#{name}=") { |val| value = val }
    #     define_singleton_method(name) { value }
    #   else
    #     raise RuntimeError, "Attribute '#{name}' is already defined."
    #   end
    # end

    # def remove_attribute(name)
    #   if instance_variable_defined?("@#{name}")
    #     remove_instance_variable("@#{name}".to_sym)
    #     metaclass.send(:remove_method, name.to_sym)
    #     metaclass.send(:remove_method, "#{name}=".to_sym)
    #   else
    #     raise RuntimeError, "Attribute '#{name} does not exist."
    #   end
    # end

    private 

    # The reason for setting this up so actors can not go below 0 hp is
    # primarily to ensure consistency to preemptively ensure that healing 
    # abilities are not having to be edge-cased out if they are at 0 hitpoints.
    # I may change this if I can think of particular use-cases. 

    # I can see special types of attacks bringing an actor below 0 until they are resurrected with
    # a specific type of ability, but would probably best be handled by a Status of 'grievous injury' or
    # 'decimated' or something like that. That would require a check further up the chain before damage is actually dealt.

    def normalize_hitpoints
      @hitpoints = 0 if @hitpoints < 0
    end

    def normalize_experience
      @experience = 0 if @experience < 0
    end

    def metaclass
      return class << self
        self 
      end
    end

    def exp_table_exceptions
      [:exp_sets, :exp_set_name, :active_exp_set]
    end

    def initial_attributes
      [:hitpoints, :experience, :level]
    end

  end

end
