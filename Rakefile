require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'
require 'yard/rake/yardoc_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

YARD::Rake::YardocTask.new do |yardoc|
  yardoc.name = 'yard'
  yardoc.options = ['--verbose']
  yardoc.files = [
    'lib/**/*.rb'
  ]
end
