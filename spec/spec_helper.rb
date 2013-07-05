require 'rspec-puppet'
require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.module_path = File.expand_path(File.join(__FILE__, '..', 'fixtures', 'modules'))
  c.manifest_dir = File.expand_path(File.join(__FILE__, '..', 'fixtures', 'manifests'))
end
