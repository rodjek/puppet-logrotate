require 'rspec-puppet'

RSpec.configure do |c|
  c.module_path = '../'
  c.manifest_dir = 'spec/fixtures/manifests'
end
