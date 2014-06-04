# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'teamcity/version'

Gem::Specification.new do |gem|
  gem.name          = "teamcity-ruby-client"
  gem.version       = TeamCity::VERSION
  gem.authors       = ['Jason Perry']
  gem.email         = ['bosoxjay@gmail.com']
  gem.description   = %q{A Ruby wrapper for the TeamCity Rest API}
  gem.summary       = %q{Ruby wrapper for the TeamCity API}
  gem.homepage      = 'https://github.com/jperry/teamcity-ruby-client'
  gem.licenses      = ['MIT']

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  # Dependencies
  gem.add_development_dependency('rspec', '~> 2.14.1')
  gem.add_development_dependency('webmock', '~> 1.8.0')
  gem.add_development_dependency('rake', '~> 10.0.3')
  gem.add_development_dependency('pry', '~> 0.9.12')
  gem.add_development_dependency('vcr', '~> 2.4.0')
  gem.add_development_dependency('yard', '~> 0.8.5.2')
  gem.add_development_dependency('redcarpet', '~> 2.2.2')
  gem.add_development_dependency('guard-rspec', '~> 4.0.2')
  gem.add_runtime_dependency('faraday', '~> 0.9.0')
  gem.add_runtime_dependency('faraday_middleware', '~> 0.9.0')
  gem.add_runtime_dependency('hashie',  '~> 2.0.0')
end
