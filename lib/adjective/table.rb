class Table
  attr_accessor :name
  attr_reader :data

  def initialize(dir, name = nil)
    raise RuntimeError, "Invalid path to YAML file: #{dir}" if !File.exist?(dir)
    @name = name
    @data = YAML.load_file(dir)
  end

  def load(dir)
    raise RuntimeError, "Invalid path to YAML file: #{dir}" if !File.exist?(dir)
    @data = YAML.load_file(dir)
  end
end

class Table::Experience < Table
  # This class sets a 'by index' paradigm and expects an ordered set
  # to be present after being given the parsed YAML file data.

  # This is primarily to keep the access points standardized and would only require
  # someone consuming the library to call something like level.to_i to maintain the convention.

  attr_reader :thresholds

  def initialize(dir, name = nil)
    super
    @thresholds = @data[@name]

    if !@thresholds.is_a?(Array)
      raise RuntimeError, "Experience table '#{@name}' is not an Array: #{@exp_thresholds.class}"
    elsif @thresholds != @thresholds.sort
      raise RuntimeError, "Experience table '#{@name}' is not sequential: #{@exp_thresholds}"      
    end
  end

  def at_level(level)
    raise RuntimeError, "Level provided is not a Fixnum: #{level}" if !level.is_a?(Fixnum)
    return @thresholds[level]
  end

end