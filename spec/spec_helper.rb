require 'rspec-puppet'
require 'hiera'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')

  # Skip running certain tests on unsupported puppet versions
  c.filter_run_excluding :unsupported => lambda {|version|
    (ENV['PUPPET_VERSION'] =~ /^#{version.to_s}/)
  }
end
