require 'faraday'
require_relative 'version'

module TeamCity
  module Configuration
    VALID_OPTIONS_KEYS = [
      :adapter,
      :hostname,
      :api_version,
      :endpoint,
      :user_agent,
      :format
    ].freeze

    VALID_FORMATS = [:json].freeze

    DEFAULT_ADAPTER = Faraday.default_adapter

    DEFAULT_HOSTNAME = 'teamcity'.freeze

    DEFAULT_API_VERSION = '7.0'.freeze

    DEFAULT_ENDPOINT = "http://#{DEFAULT_HOSTNAME}:8111/guestAuth/app/rest/#{DEFAULT_API_VERSION}/".freeze

    DEFAULT_USER_AGENT = "TeamCity Ruby Client #{TeamCity::VERSION}".freeze

    DEFAULT_FORMAT = :json

    attr_accessor *VALID_OPTIONS_KEYS

    def self.extended(base)
      base.reset
    end

    def configure
      yield self
    end

    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Reset all configuration options to defaults
    def reset
      self.adapter        = DEFAULT_ADAPTER
      self.hostname       = DEFAULT_HOSTNAME
      self.api_version    = DEFAULT_API_VERSION
      self.endpoint       = DEFAULT_ENDPOINT
      self.user_agent     = DEFAULT_USER_AGENT
      self.format         = DEFAULT_FORMAT
    end
  end
end