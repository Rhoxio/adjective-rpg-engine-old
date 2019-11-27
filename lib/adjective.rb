module Adjective

end

Dir[File.join(__dir__, 'adjective/concerns', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'adjective', '*.rb')].each { |file| require file }



