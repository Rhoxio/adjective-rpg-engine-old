require 'yaml'
require_relative './table.rb'

module Adjective
  class Actor
    attr_accessor :hitpoints

    def initialize(name, params = {})
      @hitpoints = 1
    end

    def take_damage(damage)
      @hitpoints -= damage
      normalize_hitpoints
      return self
    end

    def heal_for(healing)
      @hitpoints += healing

    end

    def alive?
      @hitpoints > 0
    end

    def dead?
      @hitpoints == 0
    end   

    def normalize_hitpoints
      @hitpoints = 0 if @hitpoints < 0
    end

    private 

    def metaclass
      return class << self
        self 
      end
    end

    def exp_table_exceptions
      [:exp_sets, :exp_set_name, :active_exp_set]
    end

    def initial_attributes
      [:hitpoints, :level]
    end

  end

end
