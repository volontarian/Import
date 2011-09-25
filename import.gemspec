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
  s.description = "Data entity importer for Ruby and asynchronous handling"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.0"

  s.add_development_dependency "sqlite3"
end
