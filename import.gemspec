$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "import/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "import"
  s.version     = Import::VERSION
  s.authors     = ["Mathias Gawlista"]
  s.email       = ["gawlista@googlemail.com"]
  s.homepage    = "http://applic.at"
  s.summary     = "Data entity importer for Ruby and asynchronous handling"
  s.description = "Data entity importer for Ruby and asynchronous handling wrapped around activerecord-import and featured by valium and state_machine."

  #s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  
  s.add_dependency "rails", "~> 3.1.0"
  #s.add_dependency "activerecord", ">= 3.0.2"
  s.add_dependency "valium"
  s.add_dependency "state_machine"
  s.add_dependency "activerecord-import"  
  
  s.add_development_dependency "mysql2"
  s.add_development_dependency "rspec", "~> 2.6.0"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "sdoc"
end
