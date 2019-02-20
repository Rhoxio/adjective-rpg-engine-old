Dir[File.join(__dir__, 'adjective', '*.rb')].each { |file| require file }

class Adjective
  def self.test
    puts "Hello world!"
  end
end


