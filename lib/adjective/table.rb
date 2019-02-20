class Table
  attr_accessor :name
  attr_reader :data

  def initialize(dir, name = nil)
    @name = name

    if File.exist?(dir)
      @data = YAML.load_file(dir)
    else
      raise RuntimeError, "Empty path provided: #{dir}" 
    end
  end

  def load(dir)
    @data = YAML.load_file(dir)
  end
end