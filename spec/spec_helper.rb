require 'rspec/autorun'
require 'webmock/rspec'

require File.expand_path('../../lib/teamcity', __FILE__)

WebMock.disable_net_connect!(:allow_localhost => true)