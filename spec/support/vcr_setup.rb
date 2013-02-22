require 'vcr'

# See https://www.relishapp.com/vcr/vcr/v/2-4-0/docs/configuration
# for more configuration options (make sure and check the version of vcr matches)
VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end