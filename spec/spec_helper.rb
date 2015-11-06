require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |config|
  config.before :each do
    Puppet[:parser] = 'future' if ENV['PARSER'] == 'future'
  end
end
