Gem::Specification.new do |s|
  s.name        = 'adjective-rpg-engine'
  s.version     = '0.0.1'
  s.date        = '2019-02-19'
  s.summary     = "A gem to help streamline RPG development"
  s.description = "A gem to help streamline RPG development"
  s.authors     = ["Kevin Maze"]
  s.email       = 'rhoxiodbc@gmail.com'
  s.files       = ["lib/adjective.rb", "lib/adjective/actor.rb"]
  s.homepage    =
    'http://rubygems.org/gems/adhective-rpg-engine'
  s.license       = 'MIT'

  s.add_dependency "activerecord", ">= 5.2.2"

  s.add_development_dependency "rspec", ">= 3.8.0"

end