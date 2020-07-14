Gem::Specification.new do |s|
  s.name        = 'adjective'
  s.version     = '1.0.0'
  s.date        = '2020-07-14'
  s.summary     = "A gem to help streamline RPG development"
  s.description = ""
  s.authors     = ["Kevin Maze"]
  s.email       = 'rhoxiodbc@gmail.com'
  s.files       = [ "lib/adjective.rb", 
                    "lib/adjective/concerns/imbibable.rb", 
                    "lib/adjective/concerns/statusable.rb",
                    "lib/adjective/concerns/storable.rb",
                    "lib/adjective/concerns/temporable.rb",
                    "lib/adjective/concerns/vulnerable.rb",
                    "lib/adjective/item.rb",
                    "lib/adjective/status.rb",
                    "lib/adjective/table.rb"
                  ]
  s.homepage    =
    'http://rubygems.org/gems/adjective-rpg-engine'
  s.license       = 'MIT'

  s.add_development_dependency "awesome_print"
  s.add_development_dependency "rspec"

end