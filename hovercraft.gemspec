# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hovercraft/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['vanstee']
  gem.email         = ['vanstee@highgroove.com']
  gem.description   = %q{Generate a RESTful API from a directory of ActiveRecord models}
  gem.summary       = %q{There's a lot of boiler plate code that goes into
                         creating an API so why not just generate all that code
                         from the models. Just throw your models in a models
                         directory and call the server from the rackup file and
                         you have yourself a perfect API.}
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
