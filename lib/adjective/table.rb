class Table
  attr_accessor :name
  attr_reader :data

  def initialize(dir, name = nil)
    file_existence_catch(dir)
    @name = name
    @data = YAML.load_file(dir)
  end

  def load(dir)
    file_existence_catch(dir)
    @data = YAML.load_file(dir)
  end

  private

  def file_existence_catch(dir)
    raise RuntimeError, "Invalid path to YAML file: #{dir}" if !File.exist?(dir)
  end

end

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Will separate out when I get the dir structures set up properly.
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
 
class Table::Experience < Table
  # This class sets a 'by index' paradigm and expects an ordered set
  # to be present after being given the parsed YAML file data.

  # This is primarily to keep the access points standardized and would only require
  # someone consuming the library to call something like level.to_i to maintain the convention.

  attr_reader :thresholds

  def initialize(dir, name = nil)
    # raise ArgumentError
    super
    @thresholds = @data[@name]

    if !@thresholds.is_a?(Array)
      raise RuntimeError, "Experience table '#{@name}' is not an Array: #{@exp_thresholds.class}"
    elsif threshold_sorted?
      raise RuntimeError, "Experience table '#{@name}' is not sequential: #{@exp_thresholds}"      
    end
  end

  def at_level(level)
    raise RuntimeError, "Level provided is not a Fixnum: #{level}" if !level.is_a?(Fixnum)
    return @thresholds[level]
  end

  private

  def threshold_sorted?
    @thresholds != @thresholds.sort
  end

end