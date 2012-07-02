# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hovercraft/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['vanstee']
  gem.email         = ['vanstee@highgroove.com']
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.test_files    = `git ls-files -- spec/*`.split("\n")
  gem.name          = 'hovercraft'
  gem.require_paths = ['lib']
  gem.version       = Hovercraft::VERSION

  gem.add_dependency 'sinatra-activerecord'
  gem.add_dependency 'rack-contrib'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rack-test'
end
