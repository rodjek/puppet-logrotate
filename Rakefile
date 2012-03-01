require 'rake'

begin
  require 'rspec/core/rake_task'
rescue LoadError
  require 'rubygems'
  retry
end

RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

task :default => :test
