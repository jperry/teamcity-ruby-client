require 'rspec/autorun'
require 'webmock/rspec'
require_relative 'support/vcr_setup'

require File.expand_path('../../lib/teamcity', __FILE__)

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end