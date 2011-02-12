# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "book_worm/version"

Gem::Specification.new do |s|
  s.name        = "book_worm"
  s.version     = BookWorm::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tony Schneider"]
  s.email       = ["tonywok@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A simple gem for interacting with ISBNDB.com}
  s.description = %q{A simple gem for interacting with ISBNDB.com}

  s.rubyforge_project = "book_worm"

  s.add_runtime_dependency "httparty"
  s.add_development_dependency "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
