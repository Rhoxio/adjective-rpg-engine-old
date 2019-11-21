module Adjective

  module Vulnerable
    def initialize_vulnerability(hitpoints = 1, max_hitpoints = 10)
      @hitpoints = hitpoints
      @max_hitpoints = max_hitpoints
      self.class.send(:attr_accessor, :hitpoints)
      self.class.send(:attr_accessor, :max_hitpoints)
    end

    def initialize(name, params = {})
      @hitpoints = 1
    end

    def take_damage(damage)
      @hitpoints -= damage
      normalize_hitpoints
      return self
    end

    def heal_to_full
      @hitpoints = @max_hitpoints
      normalize_hitpoints
    end

    def heal_for(healing)
      @hitpoints += healing
      normalize_hitpoints
    end

    def alive?
      @hitpoints > 0
    end

    def dead?
      @hitpoints == 0
    end   

    def normalize_hitpoints
      @hitpoints = 0 if @hitpoints < 0
      @hitpoints = @max_hitpoints if @hitpoints > @max_hitpoints
    end    
  end

end