require_relative 'api'

module TeamCity
  # Wrapper for the TeamCity REST API
  #
  class Client < API
    Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}

    include TeamCity::Client::Projects
    include TeamCity::Client::BuildTypes
    include TeamCity::Client::Builds
    include TeamCity::Client::Common
    include TeamCity::Client::VCSRoots
    include TeamCity::Client::Tests
    include TeamCity::Client::BuildQueue
  end
end
