# -*- encoding: utf-8 -*-
require File.expand_path('../lib/critsend_events/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors         = ["Alexander Glushkov"]
  gem.email           = ["cutalion@gmail.com"]
  gem.description     = %q{}
  gem.summary         = %q{Accepts Critsend events with Ruby on Rails}
  gem.homepage        = ""

  gem.files           = `git ls-files`.split($\)
  gem.executables     = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files      = gem.files.grep(%r{^(test|spec|features)/})
  gem.name            = "critsend_events"
  gem.require_paths   = ["lib"]
  gem.version         = CritsendEvents::VERSION
  gem.add_dependency  'json'

  gem.add_development_dependency 'rspec', '~> 2.0'
  gem.add_development_dependency 'rake'
end
