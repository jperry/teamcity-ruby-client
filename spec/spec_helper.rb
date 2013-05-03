require 'rspec/autorun'
require 'webmock/rspec'
require_relative 'support/vcr_setup'

require File.expand_path('../../lib/teamcity', __FILE__)

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end

def stub_get(path)
  stub_request(:get, TeamCity.endpoint + path)
end

def configure_client_with_authentication
  TeamCity.reset
  TeamCity.configure do |config|
    config.endpoint       = 'http://localhost:8111/httpAuth/app/rest/7.0/'
    config.http_user      = 'teamcity-ruby-client'
    config.http_password  = 'teamcity'
  end
end